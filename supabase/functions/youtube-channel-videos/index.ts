import "@supabase/functions-js/edge-runtime.d.ts";
const YOUTUBE_API_BASE = "https://www.googleapis.com/youtube/v3";
const CHANNEL_ID = "UC8TaFP8aI0fOuqFOqs3tYyQ";

type JsonMap = Record<string, unknown>;

async function youtubeRequest(
  endpoint: string,
  params: Record<string, string>,
  apiKey: string,
): Promise<JsonMap> {
  const url = new URL(`${YOUTUBE_API_BASE}/${endpoint}`);

  for (const [key, value] of Object.entries(params)) {
    url.searchParams.set(key, value);
  }

  url.searchParams.set("key", apiKey);

  const response = await fetch(url);

  if (!response.ok) {
    const body = await response.text();
    throw new Error(
      `YouTube API error ${response.status}: ${body}`,
    );
  }

  return await response.json() as JsonMap;
}

function isoDurationToSeconds(value: string): number {
  const match = value.match(
    /^PT(?:(\d+)H)?(?:(\d+)M)?(?:(\d+)S)?$/,
  );

  if (!match) return 0;

  const hours = Number(match[1] ?? 0);
  const minutes = Number(match[2] ?? 0);
  const seconds = Number(match[3] ?? 0);

  return hours * 3600 + minutes * 60 + seconds;
}

function asMap(value: unknown): JsonMap | null {
  return value !== null && typeof value === "object"
    ? value as JsonMap
    : null;
}

function asMapList(value: unknown): JsonMap[] {
  return Array.isArray(value)
    ? value.filter(
        (item): item is JsonMap =>
          item !== null && typeof item === "object",
      )
    : [];
}

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
  "Access-Control-Allow-Methods": "POST, OPTIONS",
};

function jsonResponse(body: unknown, init: ResponseInit = {}) {
  return Response.json(body, {
    ...init,
    headers: {
      ...corsHeaders,
      ...(init.headers ?? {}),
    },
  });
}

export default {
  fetch: async (req) => {
    if (req.method === "OPTIONS") {
      return new Response("ok", { headers: corsHeaders });
    }
      try {
        const apiKey = Deno.env.get("YOUTUBE_API_KEY");

        if (!apiKey) {
          return jsonResponse(
            {
              error: "YOUTUBE_API_KEY is not configured.",
            },
            { status: 500 },
          );
        }

        // 1. Get AfaanKoo channel and its uploads playlist.
        const channelData = await youtubeRequest(
          "channels",
          {
            part: "contentDetails,snippet",
            id: CHANNEL_ID,
          },
          apiKey,
        );

        const channels = asMapList(channelData["items"]);

        if (channels.length === 0) {
          return jsonResponse(
            {
              error: "AfaanKoo YouTube channel was not found.",
            },
            { status: 404 },
          );
        }

        const channel = channels[0];

        if (channel["id"]?.toString() !== CHANNEL_ID) {
          return jsonResponse(
            {
              error: "Returned channel does not match AfaanKoo.",
            },
            { status: 403 },
          );
        }

        const channelContent = asMap(channel["contentDetails"]);
        const relatedPlaylists =
          asMap(channelContent?.["relatedPlaylists"]);

        const uploadsPlaylist =
          relatedPlaylists?.["uploads"]?.toString() ?? "";

        if (uploadsPlaylist.isEmpty) {
          return jsonResponse(
            {
              error: "AfaanKoo uploads playlist was not found.",
            },
            { status: 404 },
          );
        }

        // 2. Get videos ONLY from the AfaanKoo uploads playlist.
        const videos: JsonMap[] = [];
        let pageToken = "";

        do {
          const params: Record<string, string> = {
            part: "snippet,contentDetails",
            playlistId: uploadsPlaylist,
            maxResults: "50",
          };

          if (pageToken.isNotEmpty) {
            params["pageToken"] = pageToken;
          }

          const playlistData = await youtubeRequest(
            "playlistItems",
            params,
            apiKey,
          );

          const items = asMapList(playlistData["items"]);

          for (const item of items) {
            const snippet = asMap(item["snippet"]);
            const contentDetails =
              asMap(item["contentDetails"]);

            const videoId =
              contentDetails?.["videoId"]?.toString() ?? "";

            const itemChannelId =
              snippet?.["channelId"]?.toString() ?? "";

            // Extra channel-level security check.
            if (
              videoId.isEmpty ||
              itemChannelId !== CHANNEL_ID
            ) {
              continue;
            }

            const thumbnails =
              asMap(snippet?.["thumbnails"]);

            const high =
              asMap(thumbnails?.["high"]);

            const medium =
              asMap(thumbnails?.["medium"]);

            const defaultThumbnail =
              asMap(thumbnails?.["default"]);

            videos.push({
              "id": videoId,
              "youtubeVideoId": videoId,
              "youtubeChannelId": CHANNEL_ID,
              "title":
                  snippet?.["title"]?.toString() ??
                  "Viidiyoo AfaanKoo",
              "description":
                  snippet?.["description"]?.toString() ?? "",
              "thumbnail":
                  high?.["url"]?.toString() ??
                  medium?.["url"]?.toString() ??
                  defaultThumbnail?.["url"]?.toString() ??
                  "",
              "publishedAt":
                  snippet?.["publishedAt"]?.toString() ?? "",
              "videoUrl":
                  "https://www.youtube.com/watch?v=" + videoId,
              "source": "youtube",
              "channelOnly": true,
            });
          }

          pageToken =
              playlistData["nextPageToken"]?.toString() ?? "";
        } while (pageToken.isNotEmpty);

        // 3. Get duration, statistics and embeddable status.
        for (let start = 0; start < videos.length; start += 50) {
          const batch = videos.slice(
            start,
            Math.min(start + 50, videos.length),
          );

          const ids = batch
            .map(
              (video) =>
                video["youtubeVideoId"]?.toString() ?? "",
            )
            .filter((id) => id.isNotEmpty)
            .join(",");

          if (ids.isEmpty) continue;

          const details = await youtubeRequest(
            "videos",
            {
              part: "contentDetails,statistics,status",
              id: ids,
            },
            apiKey,
          );

          const detailItems = asMapList(details["items"]);

          const byId = new Map<string, JsonMap>();

          for (const item of detailItems) {
            const id = item["id"]?.toString();

            if (id) {
              byId.set(id, item);
            }
          }

          for (const video of batch) {
            const id =
              video["youtubeVideoId"]?.toString() ?? "";

            const detail = byId.get(id);

            if (!detail) continue;

            const contentDetails =
              asMap(detail["contentDetails"]);

            const statistics =
              asMap(detail["statistics"]);

            const status =
              asMap(detail["status"]);

            video["durationSeconds"] =
              isoDurationToSeconds(
                contentDetails?.["duration"]?.toString() ?? "",
              );

            video["viewCount"] =
              Number(statistics?.["viewCount"] ?? 0);

            video["likeCount"] =
              Number(statistics?.["likeCount"] ?? 0);

            video["embeddable"] =
              status?.["embeddable"] === true;
          }
        }

        const channelSnippet =
          asMap(channel["snippet"]);

        return jsonResponse({
          channel: {
            id: CHANNEL_ID,
            title:
                channelSnippet?.["title"]?.toString() ??
                "AfaanKoo",
          },
          count: videos.length,
          videos,
        });
      } catch (error) {
        console.error(
          "youtube-channel-videos:",
          error,
        );

        return jsonResponse(
          {
            error:
              "Unable to load AfaanKoo YouTube videos.",
          },
          { status: 500 },
        );
      }
  },
};






library api_literals;

const String youtubeApiSearchSongMultiResults = '''
{
  "items": [
    {
      "kind": "youtube#searchResult",
      "etag": "0Afsj4egyoH4ftL9yLT1KRbpvz4",
      "id": {
        "kind": "youtube#video",
        "videoId": "tvTRZJ-4EyI"
      }, 
      "snippet": {
        "title": "Kendrick Lamar - HUMBLE.",
        "channelTitle": "KendrickLamarVEVO"
      }
    },
    {
      "kind": "youtube#searchResult",
      "etag": "A-zbsmr9mK1_ec9Gu8QAqv8p4TY",
      "id": {
        "kind": "youtube#video",
        "videoId": "H4RELGc9su8"
      },
      "snippet": {
        "title": "HUMBLE.",
        "channelTitle": "Kendrick Lamar - Topic"
      }
    }
  ]
} ''';
const String youtubeApiGetVideoStatsResult = '''
{
    "kind": "youtube#videoListResponse",
    "etag": "xul0lfTRTFH_42tU-hAGVcRFoWM",
    "items": [
        {
            "kind": "youtube#video",
            "etag": "Fn7l9c20c8AvY94QqMomCpueSFg",
            "id": "H4RELGc9su8",
            "statistics": {
                "viewCount": "29701687",
                "likeCount": "297167",
                "dislikeCount": "38080",
                "favoriteCount": "0",
                "commentCount": "973"
            }
        }
    ],
    "pageInfo": {
        "totalResults": 1,
        "resultsPerPage": 1
    }
}
''';
const String redditApiSearchSongMultiResults = '''
{
  "kind": "Listing",
  "data": {
    "after": "t3_7j2527",
    "dist": 25,
    "children": [
      {
        "kind": "t3",
        "data": {
          "approved_at_utc": null,
          "subreddit": "HighQualityGifs",
          "selftext": "",
          "author_fullname": "t2_j0z5u",
          "saved": false,
          "mod_reason_title": null,
          "gilded": 4,
          "clicked": false,
          "title": "Kendrick Lamar - Humble (by HQGStudios)",
          "link_flair_richtext": [
            {
              "e": "text",
              "t": "HQG Studios /r/all"
            }
          ],
          "subreddit_name_prefixed": "r/HighQualityGifs",
          "hidden": false,
          "pwls": 6,
          "link_flair_css_class": "all 006",
          "downs": 0,
          "thumbnail_height": 73,
          "top_awarded_type": null,
          "hide_score": false,
          "name": "t3_7t4svq",
          "quarantine": false,
          "link_flair_text_color": "dark",
          "upvote_ratio": 0.86,
          "author_flair_background_color": "",
          "subreddit_type": "public",
          "ups": 30539,
          "total_awards_received": 4,
          "media_embed": {},
          "thumbnail_width": 140,
          "author_flair_template_id": null,
          "is_original_content": false,
          "user_reports": [],
          "secure_media": null,
          "is_reddit_media_domain": true,
          "is_meta": false,
          "category": null,
          "secure_media_embed": {},
          "link_flair_text": "HQG Studios /r/all",
          "can_mod_post": false,
          "score": 30539,
          "approved_by": null,
          "author_premium": true,
          "thumbnail": "https://a.thumbs.redditmedia.com/KhtB4Utgj22w17H5VtQOyYW4TUA0c6Wh7Dw5XhyAQD4.jpg",
          "edited": false,
          "created": 1517005404,
          "link_flair_type": "richtext",
          "wls": 6,
          "removed_by_category": null,
          "banned_by": null,
          "author_flair_type": "richtext",
          "domain": "v.redd.it",
          "allow_live_comments": true,
          "selftext_html": null,
          "likes": null,
          "suggested_sort": null,
          "banned_at_utc": null,
          "url_overridden_by_dest": "https://v.redd.it/0jitv35e6fc01",
          "view_count": null,
          "archived": true,
          "no_follow": false,
          "is_crosspostable": true,
          "pinned": false,
          "over_18": false,
          "awarders": [],
          "media_only": false,
          "can_gild": true,
          "spoiler": false,
          "locked": false,
          "author_flair_text": "Photoshop - After Effects",
          "treatment_tags": [],
          "visited": false,
          "removed_by": null,
          "num_reports": null,
          "distinguished": null,
          "subreddit_id": "t5_2ylxz",
          "mod_reason_by": null,
          "removal_reason": null,
          "link_flair_background_color": "",
          "id": "7t4svq",
          "is_robot_indexable": true,
          "report_reasons": null,
          "author": "_BindersFullOfWomen_",
          "discussion_type": null,
          "num_comments": 497,
          "send_replies": false,
          "whitelist_status": "all_ads",
          "contest_mode": false,
          "mod_reports": [],
          "author_patreon_flair": false,
          "crosspost_parent": "t3_7t4s1l",
          "author_flair_text_color": "dark",
          "permalink": "/r/HighQualityGifs/comments/7t4svq/kendrick_lamar_humble_by_hqgstudios/",
          "parent_whitelist_status": "all_ads",
          "stickied": false,
          "url": "https://v.redd.it/0jitv35e6fc01",
          "subreddit_subscribers": 2446487,
          "created_utc": 1516976604,
          "num_crossposts": 0,
          "media": null,
          "is_video": false
        }
      },
      {
        "kind": "t3",
        "data": {
          "approved_at_utc": null,
          "subreddit": "hiphopheads",
          "selftext": "",
          "author_fullname": "t2_b36xw",
          "saved": false,
          "mod_reason_title": null,
          "gilded": 0,
          "clicked": false,
          "title": "[FRESH] Kendrick Lamar: \\"Humble\\" (Single)",
          "link_flair_richtext": [],
          "subreddit_name_prefixed": "r/hiphopheads",
          "hidden": false,
          "pwls": 6,
          "link_flair_css_class": null,
          "downs": 0,
          "thumbnail_height": 105,
          "top_awarded_type": null,
          "hide_score": false,
          "name": "t3_62hhm2",
          "quarantine": false,
          "link_flair_text_color": "dark",
          "upvote_ratio": 0.98,
          "author_flair_background_color": null,
          "subreddit_type": "public",
          "ups": 25368,
          "total_awards_received": 0,
          "media_embed": {
            "content": "&lt;iframe width=\\"600\\" height=\\"338\\" src=\\"https://www.youtube.com/embed/tvTRZJ-4EyI?feature=oembed&amp;enablejsapi=1\\" frameborder=\\"0\\" allow=\\"accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture\\" allowfullscreen&gt;&lt;/iframe&gt;",
            "width": 600,
            "scrolling": false,
            "height": 338
          },
          "thumbnail_width": 140,
          "author_flair_template_id": null,
          "is_original_content": false,
          "user_reports": [],
          "secure_media": {
            "oembed": {
              "provider_url": "https://www.youtube.com/",
              "title": "Kendrick Lamar - HUMBLE.",
              "type": "video",
              "html": "&lt;iframe width=\\"600\\" height=\\"338\\" src=\\"https://www.youtube.com/embed/tvTRZJ-4EyI?feature=oembed&amp;enablejsapi=1\\" frameborder=\\"0\\" allow=\\"accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture\\" allowfullscreen&gt;&lt;/iframe&gt;",
              "thumbnail_width": 480,
              "height": 338,
              "width": 600,
              "version": "1.0",
              "author_name": "KendrickLamarVEVO",
              "thumbnail_height": 360,
              "thumbnail_url": "https://i.ytimg.com/vi/tvTRZJ-4EyI/hqdefault.jpg",
              "provider_name": "YouTube",
              "author_url": "https://www.youtube.com/user/KendrickLamarVEVO"
            },
            "type": "youtube.com"
          },
          "is_reddit_media_domain": false,
          "is_meta": false,
          "category": null,
          "secure_media_embed": {
            "content": "&lt;iframe width=\\"600\\" height=\\"338\\" src=\\"https://www.youtube.com/embed/tvTRZJ-4EyI?feature=oembed&amp;enablejsapi=1\\" frameborder=\\"0\\" allow=\\"accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture\\" allowfullscreen&gt;&lt;/iframe&gt;",
            "width": 600,
            "scrolling": false,
            "media_domain_url": "https://www.redditmedia.com/mediaembed/62hhm2",
            "height": 338
          },
          "link_flair_text": null,
          "can_mod_post": false,
          "score": 25368,
          "approved_by": null,
          "author_premium": false,
          "thumbnail": "image",
          "edited": false,
          "author_flair_css_class": null,
          "author_flair_richtext": [],
          "gildings": {},
          "post_hint": "rich:video",
          "content_categories": null,
          "is_self": false,
          "mod_note": null,
          "created": 1490943617,
          "link_flair_type": "text",
          "wls": 6,
          "removed_by_category": null,
          "banned_by": null,
          "author_flair_type": "text",
          "domain": "youtube.com",
          "allow_live_comments": true,
          "selftext_html": null,
          "likes": null,
          "suggested_sort": "confidence",
          "banned_at_utc": null,
          "url_overridden_by_dest": "https://www.youtube.com/watch?v=tvTRZJ-4EyI",
          "view_count": null,
          "archived": true,
          "no_follow": false,
          "is_crosspostable": true,
          "pinned": false,
          "over_18": false,
          "preview": {
            "images": [
              {
                "source": {
                  "url": "https://external-preview.redd.it/sX8mKBFFxgmhwNkjDH_m4BAFdWd8UNQsOYnN0tb2oAU.jpg?auto=webp&amp;s=18e1e753de3da3e90412264a6ad6321a60bfdf2e",
                  "width": 480,
                  "height": 360
                },
                "resolutions": [
                  {
                    "url": "https://external-preview.redd.it/sX8mKBFFxgmhwNkjDH_m4BAFdWd8UNQsOYnN0tb2oAU.jpg?width=108&amp;crop=smart&amp;auto=webp&amp;s=f9c3383a78305f21744013987a6d6e3941586c46",
                    "width": 108,
                    "height": 81
                  },
                  {
                    "url": "https://external-preview.redd.it/sX8mKBFFxgmhwNkjDH_m4BAFdWd8UNQsOYnN0tb2oAU.jpg?width=216&amp;crop=smart&amp;auto=webp&amp;s=959bac3d5517a840ae9f9d1c7bb53c29bc3c3977",
                    "width": 216,
                    "height": 162
                  },
                  {
                    "url": "https://external-preview.redd.it/sX8mKBFFxgmhwNkjDH_m4BAFdWd8UNQsOYnN0tb2oAU.jpg?width=320&amp;crop=smart&amp;auto=webp&amp;s=17e4c6b13aa37b31391cd9ac8e17f88e581c0b27",
                    "width": 320,
                    "height": 240
                  }
                ],
                "variants": {},
                "id": "MjDTj955YyQxjy9yqklAAFPVwbmL0YmiQr51XCGN7jM"
              }
            ],
            "enabled": false
          },
          "all_awardings": [],
          "awarders": [],
          "media_only": false,
          "can_gild": true,
          "spoiler": false,
          "locked": false,
          "author_flair_text": null,
          "treatment_tags": [],
          "visited": false,
          "removed_by": null,
          "num_reports": null,
          "distinguished": null,
          "subreddit_id": "t5_2rh4c",
          "mod_reason_by": null,
          "removal_reason": null,
          "link_flair_background_color": "",
          "id": "62hhm2",
          "is_robot_indexable": true,
          "report_reasons": null,
          "author": "davidjlosi",
          "discussion_type": null,
          "num_comments": 3164,
          "send_replies": false,
          "whitelist_status": "all_ads",
          "contest_mode": false,
          "mod_reports": [],
          "author_patreon_flair": false,
          "author_flair_text_color": null,
          "permalink": "/r/hiphopheads/comments/62hhm2/fresh_kendrick_lamar_humble_single/",
          "parent_whitelist_status": "all_ads",
          "stickied": false,
          "url": "https://www.youtube.com/watch?v=tvTRZJ-4EyI",
          "subreddit_subscribers": 1952092,
          "created_utc": 1490914817,
          "num_crossposts": 0,
          "media": {
            "oembed": {
              "provider_url": "https://www.youtube.com/",
              "title": "Kendrick Lamar - HUMBLE.",
              "type": "video",
              "html": "&lt;iframe width=\\"600\\" height=\\"338\\" src=\\"https://www.youtube.com/embed/tvTRZJ-4EyI?feature=oembed&amp;enablejsapi=1\\" frameborder=\\"0\\" allow=\\"accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture\\" allowfullscreen&gt;&lt;/iframe&gt;",
              "thumbnail_width": 480,
              "height": 338,
              "width": 600,
              "version": "1.0",
              "author_name": "KendrickLamarVEVO",
              "thumbnail_height": 360,
              "thumbnail_url": "https://i.ytimg.com/vi/tvTRZJ-4EyI/hqdefault.jpg",
              "provider_name": "YouTube",
              "author_url": "https://www.youtube.com/user/KendrickLamarVEVO"
            },
            "type": "youtube.com"
          },
          "is_video": false
        }
      }
    ],
    "before": null
  }
} 
''';

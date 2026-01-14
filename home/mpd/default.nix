{ pkgs, config, ... }:
let
  inherit (config.colorScheme) palette;
in
{
  home = {
    packages = with pkgs; [
      rmpc
      mpc
    ];

    file."Music/.keep".text = "";
    file."Music/Playlists/.keep".text = "";
  };

  services = {
    mpd = {
      enable = true;
      network.listenAddress = "localhost";
      network.port = 6600;
      musicDirectory = "${config.home.homeDirectory}/Music";
      playlistDirectory = "${config.home.homeDirectory}/Music/Playlists";
      extraConfig = ''
        auto_update "yes"
        follow_outside_symlinks "yes"
        follow_inside_symlinks "yes"
        audio_output {
          type "pipewire"
          name "Pipewire Sound Server"
        }
      '';
    };

    mpd-mpris = {
      enable = true;
      mpd = {
        host = "127.0.0.1";
        port = 6600;
      };
    };
  };

  xdg.configFile."rmpc/config.ron".text = ''
    #![enable(implicit_some)]
    #![enable(unwrap_newtypes)]
    #![enable(unwrap_variant_newtypes)]
    (
      address: "127.0.0.1:6600",
      password: None,
      default_album_art_path: None,
      show_song_table_header: true,
      draw_borders: true,
      browser_column_widths: [20, 38, 42],

      background_color: "${palette.base00}",
      modal_backdrop: true,
      text_color: "${palette.base04}",
      header_background_color: "${palette.base00}",
      modal_background_color: "${palette.base00}",

      preview_label_style: (fg: "${palette.base0E}"),
      preview_metadata_group_style: (fg: "${palette.base08}"),

      tab_bar: (
        active_style: (fg: "${palette.base00}", bg: "${palette.base09}", modifiers: "Bold"),
        inactive_style: (fg: "${palette.base04}", bg: "${palette.base00}", modifiers: ""),
      ),

      highlighted_item_style: (fg: "${palette.base0B}", modifiers: "Bold"),
      current_item_style: (fg: "${palette.base00}", bg: "${palette.base09}", modifiers: "Bold"),
      borders_style: (fg: "${palette.base09}", modifiers: "Bold"),
      highlight_border_style: (fg: "${palette.base09}"),

      symbols: (song: "󰝚 ", dir: " ", playlist: "󰲸 ", marker: "* ", ellipsis: "..."),

      progress_bar: (
        symbols: ["█", "█", "█", "█", "█"],
        track_style: (fg: "${palette.base01}"),
        elapsed_style: (fg: "${palette.base09}"),
        thumb_style: (fg: "${palette.base09}"),
      ),

      scrollbar: (
        symbols: ["│", "█", "▲", "▼"],
        track_style: (fg: "${palette.base09}"),
        ends_style: (fg: "${palette.base09}"),
        thumb_style: (fg: "${palette.base09}"),
      ),

      song_table_format: [
        (
          prop: (kind: Property(Artist), style: (fg: "${palette.base09}"),
            default: (kind: Text("Unknown"), style: (fg: "${palette.base0E}"))
          ),
          width: "20%",
        ),
        (
          prop: (kind: Property(Title), style: (fg: "${palette.base08}"),
            highlighted_item_style: (fg: "${palette.base04}", modifiers: "Bold"),
            default: (kind: Property(Filename), style: (fg: "${palette.base04}"))
          ),
          width: "35%",
        ),
        (
          prop: (kind: Property(Album), style: (fg: "${palette.base09}"),
            default: (kind: Text("Unknown Album"), style: (fg: "${palette.base0E}"))
          ),
          width: "30%",
        ),
        (
          prop: (kind: Property(Duration), style: (fg: "${palette.base08}"),
            default: (kind: Text("-"))
          ),
          width: "15%",
          alignment: Right,
        ),
      ],

      layout: Split(
        direction: Vertical,
        panes: [
          (size: "3", pane: Pane(Tabs)),
          (
            size: "4",
            pane: Split(
              direction: Horizontal,
              panes: [
                (
                  size: "100%",
                  pane: Split(
                    direction: Vertical,
                    panes: [
                      (size: "4", borders: "ALL", pane: Pane(Header)),
                    ]
                  )
                ),
              ]
            ),
          ),
          (
            size: "100%",
            pane: Split(
              direction: Horizontal,
              panes: [
                (size: "100%", borders: "NONE", pane: Pane(TabContent)),
              ]
            ),
          ),
          (size: "3", borders: "TOP | BOTTOM", pane: Pane(ProgressBar)),
        ],
      ),

      header: (
        rows: [
          (
            left: [
              (kind: Text(""), style: (fg: "${palette.base09}", modifiers: "Bold")),
              (kind: Property(Status(StateV2(playing_label: " ", paused_label: " ", stopped_label: " ")))),
              (kind: Text(" "), style: (fg: "${palette.base09}", modifiers: "Bold")),
              (kind: Property(Widget(ScanStatus)))
            ],
            center: [
              (kind: Property(Song(Title)), style: (fg: "${palette.base04}", modifiers: "Bold"),
                default: (kind: Property(Song(Filename)), style: (fg: "${palette.base04}", modifiers: "Bold"))
              )
            ],
            right: [
              (kind: Text("󱡬"), style: (fg: "${palette.base09}", modifiers: "Bold")),
              (kind: Property(Status(Volume)), style: (fg: "${palette.base04}", modifiers: "Bold")),
              (kind: Text("%"), style: (fg: "${palette.base09}", modifiers: "Bold"))
            ]
          ),
          (
            left: [
              (kind: Text("[ "), style: (fg: "${palette.base09}", modifiers: "Bold")),
              (kind: Property(Status(Elapsed)), style: (fg: "${palette.base04}")),
              (kind: Text(" / "), style: (fg: "${palette.base09}", modifiers: "Bold")),
              (kind: Property(Status(Duration)), style: (fg: "${palette.base04}")),
              (kind: Text(" | "), style: (fg: "${palette.base09}")),
              (kind: Property(Status(Bitrate)), style: (fg: "${palette.base04}")),
              (kind: Text(" kbps"), style: (fg: "${palette.base09}")),
              (kind: Text("]"), style: (fg: "${palette.base09}", modifiers: "Bold"))
            ],
            center: [
              (kind: Property(Song(Artist)), style: (fg: "${palette.base08}", modifiers: "Bold"),
                default: (kind: Text("Unknown Artist"), style: (fg: "${palette.base08}", modifiers: "Bold"))
              ),
              (kind: Text(" - ")),
              (kind: Property(Song(Album)), style: (fg: "${palette.base09}"),
                default: (kind: Text("Unknown Album"), style: (fg: "${palette.base09}", modifiers: "Bold"))
              )
            ],
            right: [
              (kind: Text("[ "), style: (fg: "${palette.base09}")),
              (kind: Property(Status(RepeatV2(
                on_label: "", off_label: "",
                on_style: (fg: "${palette.base04}", modifiers: "Bold"), off_style: (fg: "${palette.base03}", modifiers: "Bold")
              )))),
              (kind: Text(" | "), style: (fg: "${palette.base09}")),
              (kind: Property(Status(RandomV2(
                on_label: "", off_label: "",
                on_style: (fg: "${palette.base04}", modifiers: "Bold"), off_style: (fg: "${palette.base03}", modifiers: "Bold")
              )))),
              (kind: Text(" | "), style: (fg: "${palette.base09}")),
              (kind: Property(Status(ConsumeV2(
                on_label: "󰮯", off_label: "󰮯", oneshot_label: "󰮯󰇊",
                on_style: (fg: "${palette.base04}", modifiers: "Bold"), off_style: (fg: "${palette.base03}", modifiers: "Bold")
              )))),
              (kind: Text(" | "), style: (fg: "${palette.base09}")),
              (kind: Property(Status(SingleV2(
                on_label: "󰎤", off_label: "󰎦", oneshot_label: "󰇊", off_oneshot_label: "󱅊",
                on_style: (fg: "${palette.base04}", modifiers: "Bold"), off_style: (fg: "${palette.base03}", modifiers: "Bold")
              )))),
              (kind: Text(" ]"), style: (fg: "${palette.base09}")),
            ]
          ),
        ],
      ),

      browser_song_format: [
        (
          kind: Group([
            (kind: Property(Track)),
            (kind: Text(" "))
          ])
        ),
        (
          kind: Group([
            (kind: Property(Artist)),
            (kind: Text(" - ")),
            (kind: Property(Title)),
          ]),
          default: (kind: Property(Filename))
        ),
      ],

      tabs: [
        (
          name: "Queue",
          pane: Split(
            direction: Vertical,
            panes: [
              (
                size: "100%",
                borders: "NONE",
                pane: Split(
                  borders: "NONE",
                  direction: Horizontal,
                  panes: [
                    (
                      size: "70%",
                      borders: "ALL",
                      pane: Pane(Queue),
                    ),
                    (
                      size: "30%",
                      borders: "NONE",
                      pane: Split(
                        direction: Vertical,
                        panes: [
                          (
                            size: "75%",
                            borders: "ALL",
                            pane: Pane(AlbumArt),
                          ),
                          (
                            size: "25%",
                            borders: "NONE",
                            pane: Split(
                              direction: Vertical,
                              panes: [
                                (size: "100%", pane: Pane(Lyrics)),
                              ]
                            ),
                          ),
                        ]
                      ),
                    ),
                  ]
                ),
              ),
            ],
          ),
        ),
        (
          name: "Directories",
          pane: Split(
            direction: Horizontal,
            panes: [(size: "100%", borders: "ALL", pane: Pane(Directories))],
          ),
        ),
        (
          name: "Artists",
          pane: Split(
            direction: Horizontal,
            panes: [(size: "100%", borders: "ALL", pane: Pane(Artists))],
          ),
        ),
        (
          name: "Album Artists",
          pane: Split(
            direction: Horizontal,
            panes: [(size: "100%", borders: "ALL", pane: Pane(AlbumArtists))],
          ),
        ),
        (
          name: "Albums",
          pane: Split(
            direction: Horizontal,
            panes: [(size: "100%", borders: "ALL", pane: Pane(Albums))],
          ),
        ),
        (
          name: "Playlists",
          pane: Split(
            direction: Horizontal,
            panes: [(size: "100%", borders: "ALL", pane: Pane(Playlists))],
          ),
        ),
        (
          name: "Search",
          pane: Split(
            direction: Horizontal,
            panes: [(size: "100%", borders: "ALL", pane: Pane(Search))],
          ),
        ),
        (
          name: "Browser",
          pane: Split(
            direction: Horizontal,
            panes: [(size: "100%", borders: "ALL", pane: Pane(Browser(root_tag: "Artist")))],
          ),
        ),
        (
          name: "Lyrics",
          pane: Split(
            direction: Horizontal,
            panes: [(size: "100%", borders: "ALL", pane: Pane(Lyrics))],
          ),
        ),
      ],
    )
  '';
}

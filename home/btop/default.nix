{ config, ... }:
let
  inherit (config.colorScheme) palette;
in
{
  home.file.".config/btop/themes/tsuki.theme".text = ''
    theme[main_bg]="#${palette.base00}"
    theme[main_fg]="#${palette.base05}"
    theme[title]="#${palette.base0D}"
    theme[hi_fg]="#${palette.base0C}"
    theme[selected_bg]="#${palette.base02}"
    theme[selected_fg]="#${palette.base05}"
    theme[inactive_fg]="#${palette.base03}"
    theme[proc_misc]="#${palette.base0C}"
    theme[cpu_box]="#${palette.base0D}"
    theme[mem_box]="#${palette.base0E}"
    theme[net_box]="#${palette.base0B}"
    theme[proc_box]="#${palette.base0A}"
    theme[div_line]="#${palette.base03}"
    theme[temp_start]="#${palette.base0B}"
    theme[temp_mid]="#${palette.base0A}"
    theme[temp_end]="#${palette.base08}"
    theme[cpu_start]="#${palette.base0D}"
    theme[cpu_mid]="#${palette.base0C}"
    theme[cpu_end]="#${palette.base0E}"
    theme[free_start]="#${palette.base0B}"
    theme[free_mid]="#${palette.base0C}"
    theme[free_end]="#${palette.base0D}"
    theme[cached_start]="#${palette.base0A}"
    theme[cached_mid]="#${palette.base09}"
    theme[cached_end]="#${palette.base08}"
    theme[available_start]="#${palette.base0B}"
    theme[available_mid]="#${palette.base0C}"
    theme[available_end]="#${palette.base0D}"
    theme[used_start]="#${palette.base08}"
    theme[used_mid]="#${palette.base09}"
    theme[used_end]="#${palette.base0A}"
    theme[download_start]="#${palette.base0B}"
    theme[download_mid]="#${palette.base0C}"
    theme[download_end]="#${palette.base0D}"
    theme[upload_start]="#${palette.base0E}"
    theme[upload_mid]="#${palette.base0F}"
    theme[upload_end]="#${palette.base08}"
  '';
  programs.btop = {
    enable = true;

    settings = {
      # Theme settings
      color_theme = "tsuki";
      theme_background = true;
      truecolor = true;

      # Layout presets
      presets = "cpu:1:default,proc:0:default cpu:0:default,mem:0:default,net:0:default cpu:0:block,net:0:tty";

      # Interface settings
      vim_keys = true;
      rounded_corners = true;

      # Graph symbols
      graph_symbol = "braille";
      graph_symbol_cpu = "default";
      graph_symbol_gpu = "default";
      graph_symbol_mem = "default";
      graph_symbol_net = "default";
      graph_symbol_proc = "default";

      # Visible boxes
      shown_boxes = "cpu mem net proc";

      # Update interval
      update_ms = 2000;

      # Process settings
      proc_sorting = "cpu lazy";
      proc_reversed = false;
      proc_tree = false;
      proc_colors = true;
      proc_gradient = true;
      proc_per_core = false;
      proc_mem_bytes = true;
      proc_cpu_graphs = true;
      proc_info_smaps = false;
      proc_left = false;
      proc_filter_kernel = false;
      proc_aggregate = false;

      # CPU settings
      cpu_graph_upper = "Auto";
      cpu_graph_lower = "Auto";
      show_gpu_info = "Auto";
      cpu_invert_lower = true;
      cpu_single_graph = false;
      cpu_bottom = false;
      show_uptime = true;
      check_temp = true;
      cpu_sensor = "Auto";
      show_coretemp = true;
      cpu_core_map = "";
      temp_scale = "celsius";
      show_cpu_freq = true;
      custom_cpu_name = "";

      # Display settings
      base_10_sizes = false;
      clock_format = "%X";
      background_update = true;

      # Disk settings
      disks_filter = "";
      mem_graphs = true;
      mem_below_net = false;
      zfs_arc_cached = true;
      show_swap = true;
      swap_disk = true;
      show_disks = true;
      only_physical = true;
      use_fstab = true;
      zfs_hide_datasets = false;
      disk_free_priv = false;
      show_io_stat = true;
      io_mode = false;
      io_graph_combined = false;
      io_graph_speeds = "";

      # Network settings
      net_download = 100;
      net_upload = 100;
      net_auto = true;
      net_sync = true;
      net_iface = "";
      base_10_bitrate = "Auto";

      # Battery settings
      show_battery = true;
      selected_battery = "Auto";
      show_battery_watts = true;

      # Logging
      log_level = "WARNING";

      # GPU settings
      nvml_measure_pcie_speeds = true;
      rsmi_measure_pcie_speeds = true;
      gpu_mirror_graph = true;
      custom_gpu_name0 = "";
      custom_gpu_name1 = "";
      custom_gpu_name2 = "";
      custom_gpu_name3 = "";
      custom_gpu_name4 = "";
      custom_gpu_name5 = "";
    };
  };
}

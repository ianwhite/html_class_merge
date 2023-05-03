require "./tailwind_merge"

module HTMLClassMerge
  # This HtmlClassMerger object is configured to merge Tailwind classes.
  # TODO: make this configurable
  # TODO: split up into sections (layout, typography, etc.) which can be included individually
  Tailwind = TailwindMerge.new

  # common regexps
  color_num = /50|[1-9]00|950/
  filter_num = /0|50|75|90|95|100|105|110|125|150|200/
  opacity_num = /0|5|[12][05]|[3-6]0|[789][05]|100/
  color = %r{(?:inherit|transparent|current|black|white|\w+-#{color_num})(?:/#{opacity_num})?}
  number_spacing = /px|[1-3]?\.5|[0-9]|10||11|12|14|16|20|24|28|32|36|40|44|48|52|56|60|64|72|80|96/
  twelfth_spacing = %r{1/2|[12]/3|[1-3]/4|[1-4]/5|[1-5]/6|[1-9]/12|10/12|11/12|full}
  content_spacing = %r{0|none|auto|screen|min|max|fit}

  # return a custom regexp for the prefix
  # for use in eg. pl-[13px], border-[#343434], hue-rotate-[95deg], contrast-[.25]
  custom = ->(prefix : Regex | String) { %r{\A#{prefix}-\[[^\]]+\]\z} }
  custom_number = ->(prefix : Regex | String) { %r{\A#{prefix}-\[-?\d*(?:\.\d+)?\]\z} }
  custom_duration = ->(prefix : Regex | String) { %r{\A#{prefix}-\[\d*(?:\.\d+)?(?:ms|s)\]\z} }
  custom_angle = ->(prefix : Regex | String) { %r{\A#{prefix}-\[-?\d*(?:\.\d+)?(?:deg|grad|rad|turn)\]\z} }
  custom_length = ->(prefix : Regex | String) { %r{\A#{prefix}-\[-?\d*(?:\.\d+)?(?:px|pc|em|rem|ch|vw|vh|%)\]\z} }
  custom_color = ->(prefix : Regex | String) { %r{\A#{prefix}-\[\#[^\]]+\](?:/#{opacity_num})?\z} }
  custom_property = ->(prefix : Regex | String, property : Regex | String) { %r{\A#{prefix}-\[#{property}[^\]]+\]\z} }

  # properties are defined in the same order as in the tailwind docs: https://tailwindcss.com/docs

  # ## LAYOUT ###

  # https://tailwindcss.com/docs/aspect-ratio
  Tailwind.register! :aspect, %w(auto square video).map { |i| "aspect-#{i}" }

  # https://tailwindcss.com/docs/container
  Tailwind.register! :container, "container", replace: :max_width

  # https://tailwindcss.com/docs/columns
  Tailwind.register! :columns, %r{\Acolumns-(?:1-9|10|11|12|base|xs|sm|md|lg|xl|[2-9]xl)\z},
    custom_length.call("columns")

  # https://tailwindcss.com/docs/break-after
  # https://tailwindcss.com/docs/break-before
  {break_after: "after", break_before: "before"}.each do |group, word|
    Tailwind.register! group, %w(auto avoid all avoid-page page left right column).map { |i| "break-#{word}-#{i}" }
  end

  # https://tailwindcss.com/docs/break-inside
  Tailwind.register! :break_inside, %w(auto avoid avoid-page avoid-column).map { |i| "break-inside-#{i}" }

  # https://tailwindcss.com/docs/box-decoration-break
  Tailwind.register! :box_decoration, %w(box-decoration-clone box-decoration-slice)

  # https://tailwindcss.com/docs/box-sizing
  Tailwind.register! :box_sizing, "box-border", "box-content"

  # https://tailwindcss.com/docs/display
  Tailwind.register! :display, %w(block flex tablegrid contents list-item hidden)
  Tailwind.register! :display, %w(block flex table grid).map { |i| "inline-#{i}" }
  Tailwind.register! :display, %w(caption cell column column-group footer-group header-group row-group row).map { |i| "table-#{i}" }

  # https://tailwindcss.com/docs/float
  Tailwind.register! :float, %w(left right none).map { |i| "float-#{i}" }

  # https://tailwindcss.com/docs/clear
  Tailwind.register! :clear, %w(left right both none).map { |i| "clear-#{i}" }

  # https://tailwindcss.com/docs/isolation
  Tailwind.register! :isolation, %w(isolate isolation-auto)

  # https://tailwindcss.com/docs/object-fit
  Tailwind.register! :object_fit, %w(contain cover fill none scale-down).map { |i| "object-#{i}" }

  # https://tailwindcss.com/docs/object-position
  Tailwind.register! :object_position, %w(bottom center left left-bottom left-top right right-bottom right-top top).map { |i| "object-#{i}" }

  # https://tailwindcss.com/docs/overflow
  Tailwind.register! :overflow_x, %w(auto hidden clip visible scroll).map { |i| "overflow-x-#{i}" }
  Tailwind.register! :overflow_y, %w(auto hidden clip visible scroll).map { |i| "overflow-y-#{i}" }
  Tailwind.register! :overflow, %w(auto hidden clip visible scroll).map { |i| "overflow-#{i}" },
    replace: %i(overflow_x overflow_y)

  # https://tailwindcss.com/docs/overscroll-behavior
  Tailwind.register! :overscroll_x, %w(auto contain none).map { |i| "overscroll-x-#{i}" }
  Tailwind.register! :overscroll_y, %w(auto contain none).map { |i| "overscroll-y-#{i}" }
  Tailwind.register! :overscroll, %w(auto contain none).map { |i| "overscroll-#{i}" },
    replace: %i(overscroll_x overscroll_y)

  # https://tailwindcss.com/docs/position
  Tailwind.register! :position, %w(static fixed absolute relative sticky)

  # https://tailwindcss.com/docs/top-right-bottom-left
  %i(top right bottom left start end).each do |side|
    Tailwind.register! side, %r{\A#{side}-(?:#{number_spacing}|1/2|[12]/3|[123]/4|auto|full)\z},
      %r{\A-#{side}-(?:#{number_spacing}|1/2|[12]/3|[123]/4|auto|full)\z},
      custom_length.call(side.to_s)
  end

  Tailwind.register! :inset_x, %r{\Ainset-x-(?:#{number_spacing}|1/2|[12]/3|[123]/4|auto|full)\z},
    %r{\A-inset-x-(?:#{number_spacing}|1/2|[12]/3|[123]/4|auto|full)\z},
    custom_length.call("inset-x"),
    replace: %i(left right start end)

  Tailwind.register! :inset_y, %r{\Ainset-y-(?:#{number_spacing}|1/2|[12]/3|[123]/4|auto|full)\z},
    %r{\A-inset-y-(?:#{number_spacing}|1/2|[12]/3|[123]/4|auto|full)\z},
    custom_length.call("inset-y"),
    replace: %i(top bottom)

  Tailwind.register! :inset, %r{\Ainset-(?:#{number_spacing}|1/2|[12]/3|[123]/4|auto|full)\z},
    %r{\A-inset-(?:#{number_spacing}|1/2|[12]/3|[123]/4|auto|full)\z},
    custom_length.call("inset"),
    replace: %i(inset_x inset_y top right bottom left start end)

  # https://tailwindcss.com/docs/visibility
  Tailwind.register! :visibility, %w(visible invisible)

  # https://tailwindcss.com/docs/z-index
  Tailwind.register! :z_index, %w(0 10 20 30 40 50 auto).map { |i| "z-#{i}" },
    custom_number.call("z")

  # ## FLEXBOX & GRID ###

  # https://tailwindcss.com/docs/flex-basis
  Tailwind.register! :flex_basis, %r{\Abasis-#{number_spacing}\z},
    %r{\Abasis-#{twelfth_spacing}\z},
    custom_length.call("basis")

  # https://tailwindcss.com/docs/flex-direction
  Tailwind.register! :flex_direction, %w(row row-reverse col col-reverse).map { |i| "flex-#{i}" }

  # https://tailwindcss.com/docs/flex-wrap
  Tailwind.register! :flex_wrap, %w(wrap wrap-reverse nowrap).map { |i| "flex-#{i}" }

  # https://tailwindcss.com/docs/flex
  Tailwind.register! :flex, %w(1 auto initial none).map { |i| "flex-#{i}" }

  # https://tailwindcss.com/docs/flex-grow
  Tailwind.register! :flex_grow, %w(grow grow-0)

  # https://tailwindcss.com/docs/flex-shrink
  Tailwind.register! :flex_shrink, %w(shrink shrink-0)

  # https://tailwindcss.com/docs/order
  Tailwind.register! :order, %w(1 2 3 4 5 6 7 8 9 10 11 12 first last none).map { |i| "order-#{i}" }

  # https://tailwindcss.com/docs/grid-template-columns
  Tailwind.register! :grid_template_columns, %w(1 2 3 4 5 6 7 8 9 10 11 12 none).map { |i| "grid-cols-#{i}" }

  # https://tailwindcss.com/docs/grid-column
  Tailwind.register! :grid_column, "col-auto", %w(1 2 3 4 5 6 7 8 9 10 11 12 full).map { |i| "col-span-#{i}" }
  Tailwind.register! :grid_column_start, %w(1 2 3 4 5 6 7 8 9 10 11 12 13 auto).map { |i| "col-start-#{i}" }
  Tailwind.register! :grid_column_end, %w(1 2 3 4 5 6 7 8 9 10 11 12 13 auto).map { |i| "col-end-#{i}" }

  # https://tailwindcss.com/docs/grid-template-rows
  Tailwind.register! :grid_template_rows, %w(1 2 3 4 5 6 auto).map { |i| "grid-rows-#{i}" }

  # https://tailwindcss.com/docs/grid-row
  Tailwind.register! :grid_row, "row-auto"
  Tailwind.register! :grid_row, %w(1 2 3 4 5 6 full).map { |i| "row-span-#{i}" }
  Tailwind.register! :grid_row_start, %w(1 2 3 4 5 6 7 auto).map { |i| "row-start-#{i}" }
  Tailwind.register! :grid_row_end, %w(1 2 3 4 5 6 7 auto).map { |i| "row-end-#{i}" }

  # https://tailwindcss.com/docs/grid-auto-flow
  Tailwind.register! :grid_auto_flow, %w(row col row-dense col-dense).map { |i| "grid-flow-#{i}" }

  # https://tailwindcss.com/docs/grid-auto-columns
  Tailwind.register! :grid_auto_columns, %w(auto min max fr).map { |i| "auto-cols-#{i}" }

  # https://tailwindcss.com/docs/grid-auto-rows
  Tailwind.register! :grid_auto_rows, %w(auto min max fr).map { |i| "auto-rows-#{i}" }

  # https://tailwindcss.com/docs/gap
  Tailwind.register! :gap_x, %r{\Agap-x-#{number_spacing}\z},
    custom_length.call("gap-x")

  Tailwind.register! :gap_y, %r{\Agap-y-#{number_spacing}\z},
    custom_length.call("gap-y")

  Tailwind.register! :gap, %r{\Agap-#{number_spacing}\z},
    custom_length.call("gap"),
    replace: %i(gap_x gap_y)

  # https://tailwindcss.com/docs/justify-content
  Tailwind.register! :justify_content, %w(center start end between around evenly).map { |i| "justify-#{i}" }

  # https://tailwindcss.com/docs/justify-items
  Tailwind.register! :justify_items, %w(start end center stretch).map { |i| "justify-items-#{i}" }

  # https://tailwindcss.com/docs/justify-self
  Tailwind.register! :justify_self, %w(auto start end center stretch).map { |i| "justify-self-#{i}" }

  # https://tailwindcss.com/docs/align-content
  Tailwind.register! :align_content, %w(center start end between around evenly).map { |i| "content-#{i}" }

  # https://tailwindcss.com/docs/align-items
  Tailwind.register! :align_items, %w(start end center stretch baseline).map { |i| "items-#{i}" }

  # https://tailwindcss.com/docs/align-self
  Tailwind.register! :align_self, %w(auto start end center stretch baseline).map { |i| "self-#{i}" }

  # https://tailwindcss.com/docs/place-content
  Tailwind.register! :place_content, %w(center start end between around evenly stretch).map { |i| "place-content-#{i}" }

  # https://tailwindcss.com/docs/place-items
  Tailwind.register! :place_items, %w(start end center stretch).map { |i| "place-items-#{i}" }

  # https://tailwindcss.com/docs/place-self
  Tailwind.register! :place_self, %w(auto start end center stretch).map { |i| "place-self-#{i}" }

  # ## SPACING ###

  # https://tailwindcss.com/docs/padding
  {padding_t: "t", padding_r: "r", padding_b: "b", padding_l: "l", padding_s: "s", padding_e: "e"}.each do |group, side|
    Tailwind.register! group, %r{\Ap#{side}-#{number_spacing}\z},
      custom_length.call("p#{side}")
  end

  Tailwind.register! :padding_x, %r{\Apx-#{number_spacing}\z},
    custom_length.call("px"),
    replace: %i(padding_l padding_r padding_s padding_e)

  Tailwind.register! :padding_y, %r{\Apy-#{number_spacing}\z},
    custom_length.call("py"),
    replace: %i(padding_t padding_b)

  Tailwind.register! :padding, %r{\Ap-#{number_spacing}\z},
    custom_length.call("p"),
    replace: %i(padding_x padding_y padding_l padding_r padding_t padding_b padding_s padding_e)

  # https://tailwindcss.com/docs/margin
  {margin_t: "t", margin_r: "r", margin_b: "b", margin_l: "l", margin_s: "s", margin_e: "e"}.each do |group, side|
    Tailwind.register! group, "m#{side}-auto",
      %r{\Am#{side}-#{number_spacing}\z},
      %r{\A-m#{side}-#{number_spacing}\z},
      custom_length.call("m#{side}")
  end

  Tailwind.register! :margin_x, "mx-auto",
    %r{\Amx-#{number_spacing}\z},
    %r{\A-mx-#{number_spacing}\z},
    custom_length.call("mx"),
    replace: %i(margin_l margin_r margin_s margin_e space_x)

  Tailwind.register! :margin_y, "my-auto",
    %r{\Amy-#{number_spacing}\z},
    %r{\A-my-#{number_spacing}\z},
    custom_length.call("my"),
    replace: %i(margin_t margin_b space_y)

  Tailwind.register! :margin, "m-auto",
    %r{\Am-#{number_spacing}\z},
    %r{\A-m-#{number_spacing}\z},
    custom_length.call("m"),
    replace: %i(margin_x margin_y margin_l margin_r margin_t margin_b margin_s margin_e space_x space_y)

  # https://tailwindcss.com/docs/space
  Tailwind.register! :space_x, %r{\Aspace-x-#{number_spacing}\z},
    %r{\A-space-x-#{number_spacing}\z},
    custom_length.call("space-x"),
    replace: %i(margin_x margin_l margin_r margin_s margin_e)

  Tailwind.register! :space_y, %r{\Aspace-y-#{number_spacing}\z},
    %r{\A-space-y-#{number_spacing}\z},
    custom_length.call("space-y"),
    replace: %i(margin_y margin_t margin_b)

  # ## SPACING ###

  # https://tailwindcss.com/docs/width
  Tailwind.register! :width, %r{\Aw-(?:#{number_spacing}|#{twelfth_spacing}|#{content_spacing})\z},
    custom_length.call("w")

  # https://tailwindcss.com/docs/min-width
  Tailwind.register! :min_width, %r{\Amin-w-#{content_spacing}\z},
    custom_length.call("min-w")

  # https://tailwindcss.com/docs/max-width
  Tailwind.register! :max_width, %r{\Amax-w-(?:#{content_spacing}|base|xs|sm|md|lg|xl|[2-9]xl|screen-(?:xs|sm|md|lg|xl|2xl))\z},
    "max-w-prose",
    custom_length.call("max-w"),
    replace: :container

  # https://tailwindcss.com/docs/height
  Tailwind.register! :height, %r{\Ah-(?:#{number_spacing}|#{twelfth_spacing}|#{content_spacing})\z},
    custom_length.call("h")

  # https://tailwindcss.com/docs/min-height
  Tailwind.register! :min_height, %r{\Amin-h-#{content_spacing}\z},
    custom_length.call("min-h")

  # https://tailwindcss.com/docs/max-height
  Tailwind.register! :max_height, %r{\Amax-h-(?:#{number_spacing}|#{content_spacing})\z},
    custom_length.call("max-h")

  # ## TYPOGRAPHY ###

  # https://tailwindcss.com/docs/font-family
  Tailwind.register! :font_family, %w(sans serif mono).map { |i| "font-#{i}" }

  # https://tailwindcss.com/docs/font-size
  Tailwind.register! :font_size, %w(xs sm base lg xl 2xl 3xl 4xl 5xl 6xl 7xl 8xl 9xl).map { |i| "text-#{i}" },
    custom_length.call("text")

  # https://tailwindcss.com/docs/font-smoothing
  Tailwind.register! :font_smoothing, %w(antialiased subpixel-antialiased)

  # https://tailwindcss.com/docs/font-style
  Tailwind.register! :font_style, %w(normal italic)

  # https://tailwindcss.com/docs/font-weight
  Tailwind.register! :font_weight, %w(hairline thin light normal medium semibold bold extrabold black).map { |i| "font-#{i}" },
    custom.call("font")

  # https://tailwindcss.com/docs/letter-spacing
  Tailwind.register! :letter_spacing, %w(tighter tight normal wide wider widest).map { |i| "tracking-#{i}" },
    custom_length.call("tracking")

  # https://tailwindcss.com/docs/line-clamp
  Tailwind.register! :line_clamp, %w(1 2 3 4 5 6 none).map { |i| "line-clamp-#{i}" }

  # https://tailwindcss.com/docs/line-height
  Tailwind.register! :line_height, %w(3 4 5 6 7 8 9 10 none tight snug normal relaxed loose).map { |i| "leading-#{i}" },
    custom_length.call("leading")

  # https://tailwindcss.com/docs/list-style-type
  Tailwind.register! :list_style_type, %w(none disc decimal).map { |i| "list-#{i}" }

  # https://tailwindcss.com/docs/list-style-position
  Tailwind.register! :list_style_position, %w(outside inside).map { |i| "list-#{i}" }

  # https://tailwindcss.com/docs/text-align
  Tailwind.register! :text_align, %w(left center right justify).map { |i| "text-#{i}" }

  # https://tailwindcss.com/docs/text-color
  Tailwind.register! :text_color, %r{\Atext-#{color}\z},
    custom_color.call("text")

  # https://tailwindcss.com/docs/text-decoration
  Tailwind.register! :text_decoration, %w(underline overline line-through no-underline)

  # https://tailwindcss.com/docs/text-decoration-color
  Tailwind.register! :text_decoration_color, %r{\Adecoration-#{color}\z},
    custom_color.call("decoration")

  # https://tailwindcss.com/docs/text-decoration-style
  Tailwind.register! :text_decoration_style, %w(solid double dotted dashed wavy).map { |i| "decoration-#{i}" }

  # https://tailwindcss.com/docs/text-decoration-thickness
  Tailwind.register! :text_decoration_thickness, %w(auto from-font 0 1 2 4 8).map { |i| "decoration-#{i}" },
    custom_length.call("decoration")

  # https://tailwindcss.com/docs/text-underline-offset
  Tailwind.register! :text_underline_offset, %w(auto 0 1 2 4 8).map { |i| "underline-offset-#{i}" },
    custom_length.call("underline-offset")

  # https://tailwindcss.com/docs/text-transform
  Tailwind.register! :text_transform, %w(uppercase lowercase capitalize normal-case)

  # https://tailwindcss.com/docs/text-overflow
  Tailwind.register! :text_overflow, %w(truncate text-ellipsis text-clip)

  # https://tailwindcss.com/docs/text-indent
  Tailwind.register! :text_indent, %r{\Aindent-#{number_spacing}\z},
    custom_length.call("indent")

  # https://tailwindcss.com/docs/vertical-align
  Tailwind.register! :vertical_align, %w(baseline top middle bottom text-top text-bottom sub super).map { |i| "align-#{i}" }

  # https://tailwindcss.com/docs/whitespace
  Tailwind.register! :whitespace, %w(normal nowrap pre pre-line pre-wrap).map { |i| "whitespace-#{i}" }

  # https://tailwindcss.com/docs/word-break
  Tailwind.register! :word_break, %w(break-normal break-words break-all)

  # https://tailwindcss.com/docs/content
  Tailwind.register! :content, "content-none", custom.call("content")

  # ## BACKGROUND ###

  # https://tailwindcss.com/docs/background-attachment
  Tailwind.register! :background_attachment, %w(fixed local scroll).map { |i| "bg-#{i}" }

  # https://tailwindcss.com/docs/background-clip
  Tailwind.register! :background_clip, %w(border padding content text).map { |i| "bg-#{i}" }

  # https://tailwindcss.com/docs/background-color
  Tailwind.register! :background_color, %r{\Abg-#{color}\z},
    custom_color.call("bg")

  # https://tailwindcss.com/docs/background-origin
  Tailwind.register! :background_origin, %w(border padding content).map { |i| "bg-origin-#{i}" }

  # https://tailwindcss.com/docs/background-position
  Tailwind.register! :background_position, %w(bottom center left left-bottom left-top right right-bottom right-top top).map { |i| "bg-#{i}" }

  # https://tailwindcss.com/docs/background-repeat
  Tailwind.register! :background_repeat, %w(no-repeat repeat repeat-x repeat-y round space).map { |i| "bg-#{i}" }

  # https://tailwindcss.com/docs/background-size
  Tailwind.register! :background_size, %w(auto cover contain).map { |i| "bg-#{i}" }

  # https://tailwindcss.com/docs/background-image
  Tailwind.register! :background_image, "bg-none",
    %w(t tr r br b bl l tl).map { |i| "bg-gradient-to-#{i}" },
    custom_property.call("bg", "url")

  # https://tailwindcss.com/docs/gradient-color-stops
  Tailwind.register! :gradient_color_stops_from, %r{\Afrom-#{color}\z}, custom_color.call("from")
  Tailwind.register! :gradient_color_stops_to, %r{\Ato-#{color}\z}, custom_color.call("to")
  Tailwind.register! :gradient_color_stops_via, %r{\Avia-#{color}\z}, custom_color.call("via")

  # ## BORDER ###

  # https://tailwindcss.com/docs/border-radius
  border_radius_sizes = ->(prefix : String?) do
    %w(none sm md lg xl 2xl 3xl full).map { |i| ["rounded", prefix, i].compact.join("-") }
  end

  Tailwind.register! :border_radius, "rounded",
    %w(none sm md lg xl 2xl 3xl full).map { |i| "rounded-#{i}" },
    custom_length.call("rounded")

  {
    border_radius_ss: "ss",
    border_radius_se: "se",
    border_radius_ee: "ee",
    border_radius_es: "es",
    border_radius_tl: "tl",
    border_radius_tr: "tr",
    border_radius_bl: "bl",
    border_radius_br: "br",
  }.each do |group, corner|
    Tailwind.register! group, "rounded-#{corner}",
      %w(none sm md lg xl 2xl 3xl full).map { |i| "rounded-#{corner}-#{i}" },
      custom_length.call("rounded-#{corner}")
  end

  {
    {:border_radius_s, "s", %i(border_radius_ss border_radius_se)},
    {:border_radius_e, "e", %i(border_radius_es border_radius_ee)},
    {:border_radius_t, "t", %i(border_radius_tl border_radius_tr)},
    {:border_radius_b, "b", %i(border_radius_bl border_radius_br)},
    {:border_radius_l, "l", %i(border_radius_tl border_radius_bl)},
    {:border_radius_r, "r", %i(border_radius_tr border_radius_br)},
  }.each do |(group, side, corners)|
    Tailwind.register! group, "rounded-#{side}",
      %w(none sm md lg xl 2xl 3xl full).map { |i| "rounded-#{side}-#{i}" },
      custom_length.call("rounded-#{side}"),
      replace: corners
  end

  # https://tailwindcss.com/docs/border-width
  {
    border_width_s: "s",
    border_width_e: "e",
    border_width_t: "t",
    border_width_b: "b",
    border_width_l: "l",
    border_width_r: "r",
  }.each do |group, side|
    Tailwind.register! group, "border-#{side}",
      %w(0 1 2 4 8).map { |i| "border-#{side}-#{i}" },
      custom_length.call("border-#{side}")
  end

  Tailwind.register! :border_width_x, "border-x",
    %w(0 1 2 4 8).map { |i| "border-x-#{i}" },
    custom_length.call("border-x"),
    replace: %i(border_width_l border_width_r border_width_e border_width_s)

  Tailwind.register! :border_width_y, "border-y",
    %w(0 1 2 4 8).map { |i| "border-y-#{i}" },
    custom_length.call("border-y"),
    replace: %i(border_width_t border_width_b)

  Tailwind.register! :border_width, "border",
    %w(0 1 2 4 8).map { |i| "border-#{i}" },
    custom_length.call("border"),
    replace: %i(border_width_t border_width_b border_width_l border_width_r border_width_e border_width_s)

  # https://tailwindcss.com/docs/border-color
  {
    border_color_s: "s",
    border_color_e: "e",
    border_color_t: "t",
    border_color_b: "b",
    border_color_l: "l",
    border_color_r: "r",
  }.each do |group, side|
    Tailwind.register! group, %r{\Aborder-#{side}-#{color}\z},
      custom_color.call("border-#{side}")
  end

  Tailwind.register! :border_color_x, %r{\Aborder-x-#{color}\z},
    custom_color.call("border-x"),
    replace: %i(border_color_l border_color_r border_color_e border_color_s)

  Tailwind.register! :border_color_y, %r{\Aborder-y-#{color}\z},
    custom_color.call("border-y"),
    replace: %i(border_color_t border_color_b)

  Tailwind.register! :border_color, %r{\Aborder-#{color}\z},
    custom_color.call("border"),
    replace: %i(border_color_x border_color_y border_color_t border_color_b border_color_l border_color_r border_color_e border_color_s)

  # https://tailwindcss.com/docs/border-style
  Tailwind.register! :border_style, %w(solid dashed dotted double hidden none).map { |i| "border-#{i}" }

  # https://tailwindcss.com/docs/divide-width
  Tailwind.register! :divide_width_x, "divide-x",
    %w(0 1 2 4 8).map { |i| "divide-x-#{i}" },
    custom_length.call("divide-x")

  Tailwind.register! :divide_width_y, "divide-y",
    %w(0 1 2 4 8).map { |i| "divide-y-#{i}" },
    custom_length.call("divide-y")

  # https://tailwindcss.com/docs/divide-color
  Tailwind.register! :divide_color, %r{\Adivide-#{color}\z},
    custom_color.call("divide")

  # https://tailwindcss.com/docs/divide-style
  Tailwind.register! :divide_style, %w(solid dashed dotted double hidden none).map { |i| "divide-#{i}" }

  # https://tailwindcss.com/docs/outline-width
  Tailwind.register! :outline_width, %w(0 1 2 4 8).map { |i| "outline-#{i}" },
    custom_length.call("outline")

  # https://tailwindcss.com/docs/outline-color
  Tailwind.register! :outline_color, %r{\Aoutline-#{color}\z},
    custom_color.call("outline")

  # https://tailwindcss.com/docs/outline-style
  Tailwind.register! :outline, "outline",
    %w(hidden solid dashed dotted double hidden none).map { |i| "outline-#{i}" }

  # https://tailwindcss.com/docs/outline-offset
  Tailwind.register! :outline_offset, %w(0 1 2 4 8).map { |i| "outline-offset-#{i}" },
    custom_length.call("outline-offset")

  # https://tailwindcss.com/docs/ring-width
  Tailwind.register! :ring_width, "ring",
    %w(0 1 2 4 8).map { |i| "ring-#{i}" },
    custom_length.call("ring")

  # https://tailwindcss.com/docs/ring-color
  Tailwind.register! :ring_color, %r{\Aring-#{color}\z}, custom_color.call("ring")

  # https://tailwindcss.com/docs/ring-offset-width
  Tailwind.register! :ring_offset_width, %w(0 1 2 4 8).map { |i| "ring-offset-#{i}" },
    custom_length.call("ring-offset")

  # https://tailwindcss.com/docs/ring-offset-color
  Tailwind.register! :ring_offset_color, %r{\Aring-offset-#{color}\z},
    custom_color.call("ring-offset")

  # ## EFFECTS ###

  # https://tailwindcss.com/docs/box-shadow
  Tailwind.register! :box_shadow, "shadow", %w(none sm md lg xl 2xl inner).map { |i| "shadow-#{i}" }

  # https://tailwindcss.com/docs/box-shadow-color
  Tailwind.register! :box_shadow_color, %r{\Ashadow-#{color}\z}, custom_color.call("shadow")

  # https://tailwindcss.com/docs/opacity
  Tailwind.register! :opacity, %r{\Aopacity-#{opacity_num}\z}, custom_number.call("opacity")

  # https://tailwindcss.com/docs/mix-blend-mode
  Tailwind.register! :mix_blend_mode, %w(normal multiply screen overlay darken lighten color-dodge color-burn hard-light soft-light difference exclusion hue saturation color luminosity plus-lighter).map { |i| "mix-blend-#{i}" }

  # https://tailwindcss.com/docs/background-blend-mode
  Tailwind.register! :background_blend_mode, %w(normal multiply screen overlay darken lighten color-dodge color-burn hard-light soft-light difference exclusion hue saturation color luminosity).map { |i| "bg-blend-#{i}" }

  # ## FILTERS ###

  # https://tailwindcss.com/docs/blur
  Tailwind.register! :blur, "blur",
    %w(none sm md lg xl 2xl 3xl).map { |i| "blur-#{i}" },
    custom_length.call("blur")

  # https://tailwindcss.com/docs/brightness
  Tailwind.register! :brightness, %r{\Abrightness-#{filter_num}\a},
    custom_number.call("brightness")

  # https://tailwindcss.com/docs/contrast
  Tailwind.register! :contrast, %r{\Acontrast-#{filter_num}\a},
    custom_number.call("contrast")

  # https://tailwindcss.com/docs/drop-shadow
  Tailwind.register! :drop_shadow, "drop-shadow",
    %w(none sm md lg xl 2xl).map { |i| "drop-shadow-#{i}" },
    custom.call("drop-shadow")

  # https://tailwindcss.com/docs/grayscale
  Tailwind.register! :grayscale, %w(grayscale grayscale-0)

  # https://tailwindcss.com/docs/hue-rotate
  Tailwind.register! :hue_rotate, %w(0 15 30 60 90 180).map { |i| "hue-rotate-#{i}" },
    custom_angle.call("hue-rotate")

  # https://tailwindcss.com/docs/invert
  Tailwind.register! :invert, %w(invert invert-0)

  # https://tailwindcss.com/docs/saturate
  Tailwind.register! :saturate, %r{\Asaturate-#{filter_num}\z},
    custom_number.call("saturate")

  # https://tailwindcss.com/docs/sepia
  Tailwind.register! :sepia, %w(sepia sepia-0)

  # https://tailwindcss.com/docs/backdrop-blur
  Tailwind.register! :backdrop_blur, "backdrop-blur",
    %w(none sm md lg xl 2xl 3xl).map { |i| "backdrop-blur-#{i}" },
    custom_length.call("backdrop-blur")

  # https://tailwindcss.com/docs/backdrop-brightness
  Tailwind.register! :backdrop_brightness, %r{\Abackdrop-brightness-#{filter_num}\z},
    custom_number.call("backdrop-brightness")

  # https://tailwindcss.com/docs/backdrop-contrast
  Tailwind.register! :backdrop_contrast, %r{\Abackdrop-contrast-#{filter_num}\z},
    custom_number.call("backdrop-contrast")

  # https://tailwindcss.com/docs/backdrop-grayscale
  Tailwind.register! :backdrop_grayscale, %w(backdrop-grayscale backdrop-grayscale-0)

  # https://tailwindcss.com/docs/backdrop-hue-rotate
  Tailwind.register! :backdrop_hue_rotate, %r{\Abackdrop-hue-rotate-(?:0|15|30|60|90|180)\z},
    custom_angle.call("backdrop-hue-rotate")

  # https://tailwindcss.com/docs/backdrop-invert
  Tailwind.register! :backdrop_invert, %w(backdrop-invert backdrop-invert-0)

  # https://tailwindcss.com/docs/backdrop-opacity
  Tailwind.register! :backdrop_opacity, %r{\Abackdrop-opacity-#{opacity_num}\z},
    custom_number.call("backdrop-opacity")

  # https://tailwindcss.com/docs/backdrop-saturate
  Tailwind.register! :backdrop_saturate, %r{\Abackdrop-saturate-#{filter_num}\z},
    custom_number.call("backdrop-saturate")

  # https://tailwindcss.com/docs/backdrop-sepia
  Tailwind.register! :backdrop_sepia, %w(backdrop-sepia backdrop-sepia-0)

  # ## TABLES ###

  # https://tailwindcss.com/docs/border-collapse
  Tailwind.register! :border_collapse, %w(border-collapse border-separate)

  # https://tailwindcss.com/docs/border-spacing
  Tailwind.register! :border_spacing, %r{\Aborder-spacing-#{number_spacing}\z},
    custom_length.call("border-spacing")

  # https://tailwindcss.com/docs/table-layout
  Tailwind.register! :table_layout, %w(table-auto table-fixed)

  # https://tailwindcss.com/docs/caption-side
  Tailwind.register! :caption_side, %w(caption-top caption-bottom)

  # ## TRANSITIONS ###

  # https://tailwindcss.com/docs/transition-property
  Tailwind.register! :transition_property, "transition",
    %w(none all colors opactity shadow transform).map { |i| "transition-#{i}" }

  # https://tailwindcss.com/docs/transition-duration
  Tailwind.register! :transition_duration, %w(0 75 100 150 200 300 500 700 1000).map { |i| "duration-#{i}" },
    custom_duration.call("duration")

  # https://tailwindcss.com/docs/transition-timing-function
  Tailwind.register! :transition_timing_function, %w(linear in out in-out).map { |i| "ease-#{i}" },
    custom.call("ease")

  # https://tailwindcss.com/docs/transition-delay
  Tailwind.register! :transition_delay, %w(0 75 100 150 200 300 500 700 1000).map { |i| "delay-#{i}" },
    custom_duration.call("delay")

  # https://tailwindcss.com/docs/animation
  Tailwind.register! :animation, %w(none spin ping pulse bounce).map { |i| "animate-#{i}" },
    custom.call("animate")

  # ## TRANSFORMS ###

  # https://tailwindcss.com/docs/scale
  Tailwind.register! :scale, %w(0 50 75 90 95 100 105 110 125 150).flat_map { |i| ["scale-#{i}", "-scale-#{i}"] },
    custom_number.call("scale"),
    replace: %i(scale_x scale_y)

  Tailwind.register! :scale_x, %w(0 50 75 90 95 100 105 110 125 150).flat_map { |i| ["scale-x-#{i}", "-scale-x-#{i}"] },
    custom_number.call("scale-x")

  Tailwind.register! :scale_y, %w(0 50 75 90 95 100 105 110 125 150).flat_map { |i| ["scale-y-#{i}", "-scale-y-#{i}"] },
    custom_number.call("scale-y")

  # https://tailwindcss.com/docs/rotate
  Tailwind.register! :rotate, %w(0 1 2 3 6 12 45 90 180).flat_map { |i| ["rotate-#{i}", "-rotate-#{i}"] },
    custom_angle.call("rotate")

  # https://tailwindcss.com/docs/translate
  Tailwind.register! :translate_x, %r{\Atranslate-x-(?:#{number_spacing}|1/2|[12]/3|[123]/4|auto|full)\z},
    %r{\A-translate-x-(?:#{number_spacing}|1/2|[12]/3|[123]/4|auto|full)\z},
    custom_length.call("translate-x")

  Tailwind.register! :translate_y, %r{\Atranslate-Y-(?:#{number_spacing}|1/2|[12]/3|[123]/4|auto|full)\z},
    %r{\A-translate-Y-(?:#{number_spacing}|1/2|[12]/3|[123]/4|auto|full)\z},
    custom_length.call("translate-Y")

  # https://tailwindcss.com/docs/skew
  Tailwind.register! :skew_x, %w(0 1 2 3 6 12).flat_map { |i| ["skew-x-#{i}", "-skew-x-#{i}"] },
    custom_angle.call("skew-x")

  Tailwind.register! :skew_y, %w(0 1 2 3 6 12).flat_map { |i| ["skew-y-#{i}", "-skew-y-#{i}"] },
    custom_angle.call("skew-y")

  # https://tailwindcss.com/docs/transform-origin
  Tailwind.register! :transform_origin, %w(center top top-right right bottom-right bottom bottom-left left top-left).map { |i| "origin-#{i}" },
    custom.call("origin")

  # ## INTERACTIVITY ###

  # https://tailwindcss.com/docs/accent-color
  Tailwind.register! :accent_color, %r{\Aaccent-#{color}\z}, custom_color.call("accent")

  # https://tailwindcss.com/docs/appearance
  # only one property

  # https://tailwindcss.com/docs/cursor
  Tailwind.register! :cursor, %w(auto default pointer wait text move help not-allowed none
    context-menu progress cell crosshair vertical-text alias
    copy no-drop grab grabbing all-scroll zoom-in zoom-out).map { |i| "cursor-#{i}" },
    %w(col row n e s w ne nw se sw ew ns nesw nwse).map { |i| "cursor-#{i}-resize" },
    custom.call("cursor")

  # https://tailwindcss.com/docs/caret-color
  Tailwind.register! :caret_color, %r{\Acaret-#{color}\z}, custom_color.call("caret")

  # https://tailwindcss.com/docs/pointer-events
  Tailwind.register! :pointer_events, %w(pointer-events-none pointer-events-auto)

  # https://tailwindcss.com/docs/resize
  Tailwind.register! :resize, "resize", %w(none x y).map { |i| "resize-#{i}" }

  # https://tailwindcss.com/docs/scroll-behavior
  Tailwind.register! :scroll_behaviour, %w(scroll-auto scroll-smooth)

  # https://tailwindcss.com/docs/scroll-margin
  Tailwind.register! :scroll_margin, %r{\Ascroll-m-#{number_spacing}\z},
    %r{\A-scroll-m-#{number_spacing}\z},
    custom_length.call("scroll-m"),
    replace: %i(scroll_margin_x scroll_margin_y scroll_margin_t scroll_margin_r scroll_margin_b scroll_margin_l scroll_margin_s scroll_margin_e)

  Tailwind.register! :scroll_margin_x, %r{\Ascroll-mx-#{number_spacing}\z},
    %r{\A-scroll-mx-#{number_spacing}\z},
    custom_length.call("scroll-mx"),
    replace: %i(scroll_margin_r scroll_margin_l scroll_margin_s scroll_margin_e)

  Tailwind.register! :scroll_margin_y, %r{\Ascroll-my-#{number_spacing}\z},
    %r{\A-scroll-my-#{number_spacing}\z},
    custom_length.call("scroll-my"),
    replace: %i(scroll_margin_t scroll_margin_b)

  {
    scroll_margin_t: "t",
    scroll_margin_r: "r",
    scroll_margin_b: "b",
    scroll_margin_l: "l",
    scroll_margin_s: "s",
    scroll_margin_e: "e",
  }.each do |group, side|
    Tailwind.register! group, %r{\Ascroll-m#{side}-#{number_spacing}\z},
      %r{\A-scroll-m#{side}-#{number_spacing}\z},
      custom_length.call("scroll-m#{side}")
  end

  # https://tailwindcss.com/docs/scroll-padding
  Tailwind.register! :scroll_padding, %r{\Ascroll-p-#{number_spacing}\z},
    %r{\A-scroll-p-#{number_spacing}\z},
    custom_length.call("scroll-p"),
    replace: %i(scroll_padding_x scroll_padding_y scroll_padding_t scroll_padding_r scroll_padding_b scroll_padding_l scroll_padding_s scroll_padding_e)

  Tailwind.register! :scroll_padding_x, %r{\Ascroll-px-#{number_spacing}\z},
    %r{\A-scroll-px-#{number_spacing}\z},
    custom_length.call("scroll-px"),
    replace: %i(scroll_padding_r scroll_padding_l scroll_padding_s scroll_padding_e)

  Tailwind.register! :scroll_padding_y, %r{\Ascroll-py-#{number_spacing}\z},
    %r{\A-scroll-py-#{number_spacing}\z},
    custom_length.call("scroll-py"),
    replace: %i(scroll_padding_t scroll_padding_b)
  {
    scroll_padding_t: "t",
    scroll_padding_r: "r",
    scroll_padding_b: "b",
    scroll_padding_l: "l",
    scroll_padding_s: "s",
    scroll_padding_e: "e",
  }.each do |group, side|
    Tailwind.register! group, %r{\Ascroll-p#{side}-#{number_spacing}\z},
      %r{\A-scroll-p#{side}-#{number_spacing}\z},
      custom_length.call("scroll-p#{side}")
  end

  # https://tailwindcss.com/docs/scroll-snap-align
  Tailwind.register! :scroll_snap_align, %w(start end center align-none).map { |i| "snap-#{i}" }

  # https://tailwindcss.com/docs/scroll-snap-stop
  Tailwind.register! :scroll_snap_stop, %w(normal always).map { |i| "snap-#{i}" }

  # https://tailwindcss.com/docs/scroll-snap-type
  Tailwind.register! :scroll_snap_type, %w(none x y both mandatory proximity).map { |i| "snap-#{i}" }

  # https://tailwindcss.com/docs/touch-action
  Tailwind.register! :touch_action, %w(auto none pinch-zoom manipulation).map { |i| "touch-#{i}" },
    %w(x left right y up down).map { |i| "touch-pan-#{i}" }

  # https://tailwindcss.com/docs/user-select
  Tailwind.register! :user_select, %w(none text all auto).map { |i| "select-#{i}" }

  # https://tailwindcss.com/docs/will-change
  Tailwind.register! :will_change, %w(auto scroll contents transform).map { |i| "will-change-#{i}" }

  # ## SVG ###

  # https://tailwindcss.com/docs/fill
  Tailwind.register! :fill, %r{\Afill-#{color}\z}, custom_color.call("fill")

  # https://tailwindcss.com/docs/stroke
  Tailwind.register! :stroke, %r{\Astroke-#{color}\z}, custom_color.call("stroke")

  # https://tailwindcss.com/docs/stroke-width
  Tailwind.register! :stroke_width, %w(0 1 2).map { |i| "stroke-#{i}" }, custom_length.call("stroke")

  # ## ACCESSIBILITY ###

  # https://tailwindcss.com/docs/screen-readers
  Tailwind.register! :screen_readers, %w(sr-only not-sr-only)

  # ## OFFICIAL PLUGINS ###

  # https://tailwindcss.com/docs/typography-plugin
  # only one property

  # https://github.com/tailwindlabs/tailwindcss-forms
  Tailwind.register! :form_control, %w(input textarea select multiselect checkbox radio).map { |i| "form-#{i}" }

  # https://github.com/tailwindlabs/tailwindcss-aspect-ratio
  Tailwind.register! :aspect_w, %w(1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16).map { |i| "aspect-w-#{i}" }, replace: :aspect
  Tailwind.register! :aspect_h, %w(1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16).map { |i| "aspect-h-#{i}" }, replace: :aspect
  Tailwind.register! :aspect, replace: %i(aspect_w aspect_h)

  # https://github.com/tailwindlabs/tailwindcss-container-queries
  # should be handled by tailwind scopes
end

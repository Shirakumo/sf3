meta:
  id: sf3_text
  file-extension: txt.sf3
  title: SF3 Text
  license: zlib
  ks-version: 0.8
  encoding: ASCII
  endian: le
doc-ref: https://shirakumo.org/docs/sf3
seq:
  - id: magic
    contents: [0x81, "SF3", 0x00, 0xE0, 0xD0, 0x0D, 0x0A, 0x0A]
  - id: format_id
    contents: [0x08]
  - id: checksum
    type: u4
  - id: null_terminator
    contents: [0]
  - id: text
    type: text
types:
  text:
    seq:
      - id: markup_size
        type: u8
      - id: markup_count
        type: u4
      - id: markup
        type: markup
        repeat: expr
        repeat-expr: markup_count
      - id: text_length
        type: u8
      - id: text
        type: strz
        encoding: UTF-8
        size: text_length
  markup:
    seq:
      - id: start
        type: u8
      - id: end
        type: u8
      - id: option_type
        type: u1
        enum: option_types
      - id: option_data
        type:
          switch-on: option_type
          cases:
            'option_types::bold': bold
            'option_types::italic': italic
            'option_types::underline': underline
            'option_types::strike': strike
            'option_types::mono': mono
            'option_types::color': color
            'option_types::size': size
            'option_types::heading': heading
            'option_types::link': link
            'option_types::target': target
  bold: {}
  italic: {}
  underline: {}
  strike: {}
  mono: {}
  color:
    seq:
      - id: r
        type: f4
      - id: g
        type: f4
      - id: b
        type: f4
  size:
    seq:
      - id: size
        type: f4
  heading:
    seq:
      - id: level
        type: u1
  link:
    seq:
      - id: address_length
        type: u2
      - id: address
        type: strz
        size: address_length
  target:
    seq:
      - id: address_length
        type: u2
      - id: address
        type: strz
        size: address_length
enums:
  option_types:
    0x01: bold
    0x02: italic
    0x03: underline
    0x04: strike
    0x05: mono
    0x06: color
    0x07: size
    0x08: heading
    0x09: link
    0x0A: target

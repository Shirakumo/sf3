meta:
  id: sf3_image
  title: SF3 Image
  file-extension: img.sf3
  xref:
    mime: image/x.sf3
  license: zlib
  ks-version: 0.8
  encoding: UTF-8
  endian: le
doc-ref: https://shirakumo.org/docs/sf3
seq:
  - id: magic
    contents: [0x81, "SF3", 0x00, 0xE0, 0xD0, 0x0D, 0x0A, 0x0A]
  - id: format_id
    contents: [0x03]
  - id: checksum
    type: u4
  - id: null_terminator
    contents: [0]
  - id: image
    type: image
types:
  image:
    seq:
      - id: width
        type: u4
      - id: height
        type: u4
      - id: depth
        type: u4
      - id: channel_format
        type: u1
        enum: layouts
      - id: format
        type: u1
        enum: formats
      - id: samples
        repeat: expr
        repeat-expr: depth * height * width * channel_count
        type:
          switch-on: format
          cases:
            'formats::int8': s1
            'formats::int16': s2
            'formats::int32': s4
            'formats::int64': s8
            'formats::uint8': u1
            'formats::uint16': u2
            'formats::uint32': u4
            'formats::uint64': u8
            'formats::float16': f2
            'formats::float32': f4
            'formats::float64': f8
    instances:
      channel_count:
        value: channel_format.to_i & 0b1111
enums:
  layouts:
    0x01: v
    0x02: va
    0x03: rgb
    0x04: rgba
    0x12: av
    0x13: bgr
    0x14: abgr
    0x24: argb
    0x34: bgra
    0x44: cmyk
    0x54: kmyc
  formats:
    0x01: int8
    0x02: int16
    0x04: int32
    0x08: int64
    0x11: uint8
    0x12: uint16
    0x14: uint32
    0x18: uint64
    0x22: float16
    0x24: float32
    0x28: float64

meta:
  id: sf3_image
  file-extension: ar.sf3
  title: SF3 Image
  license: zlib
  ks-version: 0.8
  encoding: ASCII
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
  - id: payload
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
          switch_on: format
          cases:
            0x01: s1
            0x02: s2
            0x04: s4
            0x08: s8
            0x11: u1
            0x12: u2
            0x14: u4
            0x18: u8
            0x22: f2
            0x24: f4
            0x28: f8
instances:
  channel_count:
    value: channels & 0b1111
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

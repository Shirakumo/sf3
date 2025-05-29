meta:
  id: sf3_audio
  file-extension: ar.sf3
  title: SF3 Audio
  license: zlib
  ks-version: 0.8
  encoding: ASCII
  endian: le
doc-ref: https://shirakumo.org/docs/sf3
seq:
  - id: magic
    contents: [0x81, "SF3", 0x00, 0xE0, 0xD0, 0x0D, 0x0A, 0x0A]
  - id: format_id
    contents: [0x02]
  - id: checksum
    type: u4
  - id: null_terminator
    contents: [0]
  - id: payload
    type: audio
types:
  audio:
    seq:
      - id: samplerate
        type: u4
      - id: channels
        type: u1
      - id: format
        type: u1
        enum: formats
      - id: frame_count
        type: u8
      - id: samples
        repeat: expr
        repeat-expr: channels * frame_count
        type:
          switch_on: format
          cases:
            0x01: u1
            0x02: s2
            0x04: s4
            0x08: s8
            0x11: u1
            0x12: s2
            0x14: s4
            0x18: s8
            0x22: f2
            0x24: f4
            0x28: f8
enums:
  formats:
    0x01: uint8_alaw
    0x02: int16_pcm
    0x04: int32_pcm
    0x08: int64_pcm
    0x11: uint8_ulaw
    0x12: uint16_pcm
    0x14: uint32_pcm
    0x18: uint64_pcm
    0x22: float16_pcm
    0x24: float32_pcm
    0x28: float64_pcm

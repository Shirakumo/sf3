meta:
  id: sf3_audio
  title: SF3 Audio
  file-extension: au.sf3
  xref:
    mime: audio/x.sf3
  license: zlib
  ks-version: 0.8
  encoding: UTF-8
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
  - id: audio
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
          switch-on: format
          cases:
            'formats::uint8_alaw': u1
            'formats::int16_pcm': s2
            'formats::int32_pcm': s4
            'formats::int64_pcm': s8
            'formats::uint8_ulaw': u1
            'formats::uint16_pcm': s2
            'formats::uint32_pcm': s4
            'formats::uint64_pcm': s8
            'formats::float16_pcm': f2
            'formats::float32_pcm': f4
            'formats::float64_pcm': f8
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

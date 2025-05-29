meta:
  id: sf3_log
  title: SF3 Log
  file-extension: log.sf3
  xref:
    mime: application/x.sf3-log
  license: zlib
  ks-version: 0.8
  encoding: UTF-8
  endian: le
doc-ref: https://shirakumo.org/docs/sf3
seq:
  - id: magic
    contents: [0x81, "SF3", 0x00, 0xE0, 0xD0, 0x0D, 0x0A, 0x0A]
  - id: format_id
    contents: [0x04]
  - id: checksum
    type: u4
  - id: null_terminator
    contents: [0]
  - id: log
    type: log
types:
  string1:
    seq:
      - id: len
        type: u1
      - id: value
        type: str
        encoding: UTF-8
        size: len
  string2:
    seq:
      - id: len
        type: u2
      - id: value
        type: str
        encoding: UTF-8
        size: len
  log:
    seq:
      - id: start_time
        type: s8
      - id: chunk_count
        type: u2
      - id: chunks
        type: chunk
        repeat: expr
        repeat-expr: chunk_count
  chunk:
    seq:
      - id: chunk_size
        type: u8
      - id: entry_count
        type: u4
      - id: entry_offsets
        type: u8
        repeat: expr
        repeat-expr: entry_count
      - id: entries
        type: entry
        repeat: expr
        repeat-expr: entry_count
  entry:
    seq:
      - id: size
        type: u4
      - id: time
        type: u8
      - id: severity
        type: s8
      - id: source
        type: string1
      - id: category
        type: string1
      - id: message
        type: string2

meta:
  id: sf3_archive
  title: SF3 Archive
  file-extension: ar.sf3
  xref:
    mime: application/x.sf3-archive
  license: zlib
  ks-version: 0.8
  encoding: UTF-8
  endian: le
doc-ref: https://shirakumo.org/docs/sf3
seq:
  - id: magic
    contents: [0x81, "SF3", 0x00, 0xE0, 0xD0, 0x0D, 0x0A, 0x0A]
  - id: format_id
    contents: [0x01]
  - id: checksum
    type: u4
  - id: null_terminator
    contents: [0]
  - id: archive
    type: archive
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
  archive:
    seq:
      - id: entry_count
        type: u8
      - id: meta_size
        type: u8
      - id: meta_entry_offsets
        type: u8
        repeat: expr
        repeat-expr: entry_count
      - id: meta_entries
        type: meta_entry
        repeat: expr
        repeat-expr: entry_count
      - id: file_offsets
        type: u8
        repeat: expr
        repeat-expr: entry_count
      - id: file_payloads
        type: file
        repeat: expr
        repeat-expr: entry_count
  meta_entry:
    seq:
      - id: mod_time
        type: s8
      - id: checksum
        type: u4
      - id: mime
        type: string1
      - id: path
        type: string2
  file:
    seq:
      - id: length
        type: u8
      - id: payload
        size: length
        

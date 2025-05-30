meta:
  id: sf3_table
  file-extension: ar.sf3
  title: SF3 Table
  license: zlib
  ks-version: 0.8
  encoding: ASCII
  endian: le
doc-ref: https://shirakumo.org/docs/sf3
seq:
  - id: magic
    contents: [0x81, "SF3", 0x00, 0xE0, 0xD0, 0x0D, 0x0A, 0x0A]
  - id: format_id
    contents: [0x07]
  - id: checksum
    type: u4
  - id: null_terminator
    contents: [0]
  - id: table
    type: table
types:
  table:
    seq:
      - id: spec_length
        type: u4
      - id: column_count
        type: u2
      - id: row_length
        type: u8
      - id: row_count
        type: u8
      - id: column_specs
        type: column_spec
        repeat: expr
        repeat-expr: column_count
      - id: rows
        type: row
        repeat: expr
        repeat-expr: row_count
        size: row_length * row_count
  column_spec:
    seq:
      - id: name_length
        type: u2
      - id: name
        type: strz
        encoding: UTF-8
        size: name_length
      - id: column_length
        type: u4
      - id: column_type
        type: u1
        enum: column_types
    instances:
      element_size:
        value: 0x0F & column_length
      element_count:
        value: column_length / element_size
  row:
    seq:
      - id: cells
        type: cell(_index)
        repeat: expr
        repeat-expr: _parent.column_count
  cell:
    params:
      - id: column
        type: u2
    seq:
      - id: elements
        repeat: expr
        repeat-expr: _root.table.column_specs[column].element_count
        type:
          switch-on: _root.table.column_specs[column].column_type
          cases:
            'column_types::uint8': u1
            'column_types::uint16': u2
            'column_types::uint32': u4
            'column_types::uint64': u8
            'column_types::int8': s1
            'column_types::int16': s2
            'column_types::int32': s4
            'column_types::int64': s8
            'column_types::float16': f2
            'column_types::float32': f4
            'column_types::float64': f8
            'column_types::string': strz
            'column_types::timestamp': s8
            'column_types::high_resolution_timestamp': u8
            'column_types::boolean': u1
  f2:
    seq:
      - id: bits
        type: u2
enums:
  column_types:
    0x01: uint8
    0x02: uint16
    0x04: uint32
    0x08: uint64
    0x11: int8
    0x12: int16
    0x14: int32
    0x18: int64
    0x22: float16
    0x24: float32
    0x28: float64
    0x31: string
    0x48: timestamp
    0x58: high_resolution_timestamp
    0x61: boolean

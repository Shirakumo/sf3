meta:
  id: sf3_vector_graphic
  title: SF3 Vector Graphic
  file-extension: vec.sf3
  xref:
    mime: image/x.sf3-vector
  license: zlib
  ks-version: 0.8
  encoding: UTF-8
  endian: le
doc-ref: https://shirakumo.org/docs/sf3
seq:
  - id: magic
    contents: [0x81, "SF3", 0x00, 0xE0, 0xD0, 0x0D, 0x0A, 0x0A]
  - id: format_id
    contents: [0x09]
  - id: checksum
    type: u4
  - id: null_terminator
    contents: [0]
  - id: payload
    type: vector_graphic
types:
  vector_graphic:
    seq:
      - id: width
        type: u4
      - id: height
        type: u4
      - id: count
        type: u4
      - id: instructions
        type: instruction
        repeat: expr
        repeat-expr: count
  instruction:
    seq:
      - id: type
        type: u1
        enum: instruction_types
      - id: data
        type:
          switch-on: type
          cases:
            'instruction_types::line': line
            'instruction_types::rectangle': rectangle
            'instruction_types::circle': circle
            'instruction_types::polygon': polygon
            'instruction_types::curve': curve
            'instruction_types::text': text
            'instruction_types::identity': identity
            'instruction_types::matrix': matrix
  line:
    seq:
      - id: outline
        type: shape_outline
      - id: color
        type: color
      - id: thickness
        type: f4
  rectangle:
    seq:
      - id: bounds
        type: shape_bounds
      - id: fill
        type: shape_fill
  circle:
    seq:
      - id: bounds
        type: shape_bounds
      - id: fill
        type: shape_fill
  polygon:
    seq:
      - id: outline
        type: shape_outline
      - id: fill
        type: shape_fill
  curve:
    seq:
      - id: outline
        type: shape_outline
      - id: fill
        type: shape_fill
  text:
    seq:
      - id: position
        type: point
      - id: color
        type: color
      - id: font
        type: font
      - id: font_size
        type: f4
      - id: string_length
        type: u2
      - id: string
        type: strz
        encoding: UTF-8
        size: string_length
  identity: {}
  matrix:
    seq:
      - id: elements
        type: f4
        repeat: expr
        repeat-expr: 6
  font:
    seq:
      - id: font_length
        type: u2
      - id: name
        type: strz
        size: font_length
  shape_outline:
    seq:
      - id: edge_count
        type: u2
      - id: edges
        type: point
        repeat: expr
        repeat-expr: edge_count
  shape_bounds:
    seq:
      - id: point
        type: point
      - id: size
        type: size
  shape_fill:
    seq:
      - id: fill_color
        type: color
      - id: outline_color
        type: color
      - id: outline_thickness
        type: f4
  point:
    seq:
      - id: x
        type: f4
      - id: y
        type: f4
  size:
    seq:
      - id: x
        type: f4
      - id: y
        type: f4
  color:
    seq:
      - id: r
        type: f4
      - id: g
        type: f4
      - id: b
        type: f4
      - id: a
        type: f4
enums:
  instruction_types:
    0x01: line
    0x02: rectangle
    0x03: circle
    0x04: polygon
    0x05: curve
    0x06: text
    0x11: identity
    0x12: matrix

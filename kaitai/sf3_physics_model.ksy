meta:
  id: sf3_physics_model
  file-extension: phys.sf3
  title: SF3 Physics-Model
  license: zlib
  ks-version: 0.8
  encoding: ASCII
  endian: le
doc-ref: https://shirakumo.org/docs/sf3
seq:
  - id: magic
    contents: [0x81, "SF3", 0x00, 0xE0, 0xD0, 0x0D, 0x0A, 0x0A]
  - id: format_id
    contents: [0x06]
  - id: checksum
    type: u4
  - id: null_terminator
    contents: [0]
  - id: physics_model
    type: physics_model
types:
  physics_model:
    seq:
      - id: shape_count
        type: u2
      - id: mass
        type: f4
      - id: tensor
        type: f4
        repeat: expr
        repeat-expr: 9
      - id: shapes
        type: shape
        repeat: expr
        repeat-expr: shape_count
  shape:
    seq:
      - id: transform
        type: f4
        repeat: expr
        repeat-expr: 16
      - id: shape_type
        type: u1
        enum: shape_types
      - id: data
        type:
          switch-on: shape_type
          cases:
            'shape_types::ellipsoid': ellipsoid
            'shape_types::box': box
            'shape_types::cylinder': cylinder
            'shape_types::pill': pill
            'shape_types::mesh': mesh
  ellipsoid:
    seq:
      - id: width
        type: f4
      - id: height
        type: f4
      - id: depth
        type: f4
  box:
    seq:
      - id: width
        type: f4
      - id: height
        type: f4
      - id: depth
        type: f4
  cylinder:
    seq:
      - id: bottom_radius
        type: f4
      - id: top_radius
        type: f4
      - id: height
        type: f4
  pill:
    seq:
      - id: bottom_radius
        type: f4
      - id: top_radius
        type: f4
      - id: height
        type: f4
  mesh:
    seq:
      - id: vertex_count
        type: u2
      - id: vertices
        type: f4
        repeat: expr
        repeat-expr: vertex_count * 3
enums:
  shape_types:
    0x01: ellipsoid
    0x02: box
    0x03: cylinder
    0x04: pill
    0x05: mesh

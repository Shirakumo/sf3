meta:
  id: sf3_model
  file-extension: mod.sf3
  title: SF3 Model
  license: zlib
  ks-version: 0.8
  encoding: ASCII
  endian: le
doc-ref: https://shirakumo.org/docs/sf3
seq:
  - id: magic
    contents: [0x81, "SF3", 0x00, 0xE0, 0xD0, 0x0D, 0x0A, 0x0A]
  - id: format_id
    contents: [0x05]
  - id: checksum
    type: u4
  - id: null_terminator
    contents: [0]
  - id: model
    type: model
types:
  string2:
    seq:
      - id: len
        type: u2
      - id: value
        type: str
        encoding: UTF-8
        size: len
  model:
    seq:
      - id: format
        type: vertex_format
      - id: material_type
        type: material_type
      - id: material_size
        type: u4
      - id: material
        type: material
      - id: vertex_data
        type: vertex_data
  material:
    seq:
      - id: textures
        type: string2
        repeat: expr
        repeat-expr: _parent.material_type.material_count
  vertex_data:
    seq:
      - id: face_count
        type: u4
      - id: faces
        type: u4
        repeat: expr
        repeat-expr: face_count
      - id: vertex_count
        type: u4
      - id: vertices
        type: f4
        repeat: expr
        repeat-expr: vertex_count
  vertex_format:
    seq:
      - id: raw
        type: u1
    instances:
      has_position:
        value: 0 != (raw & 0x01)
      has_uv:
        value: 0 != (raw & 0x02)
      has_color:
        value: 0 != (raw & 0x04)
      has_normal:
        value: 0 != (raw & 0x08)
      has_tangent:
        value: 0 != (raw & 0x10)
  material_type:
    seq:
      - id: raw
        type: u1
    instances:
      has_albedo:
        value: 0 != (raw & 0x01)
      has_normal:
        value: 0 != (raw & 0x02)
      has_metallic:
        value: 0 != (raw & 0x04)
      has_metalness:
        value: 0 != (raw & 0x08)
      has_roughness:
        value: 0 != (raw & 0x10)
      has_occlusion:
        value: 0 != (raw & 0x20)
      has_specular:
        value: 0 != (raw & 0x40)
      has_emission:
        value: 0 != (raw & 0x80)
      material_count:
        value: >
          (raw >> 0) & 1 +
          (raw >> 1) & 1 + 
          (raw >> 2) & 1 + 
          (raw >> 3) & 1 + 
          (raw >> 4) & 1 + 
          (raw >> 5) & 1 + 
          (raw >> 6) & 1 + 
          (raw >> 7) & 1

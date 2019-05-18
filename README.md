# About SF3
SF3 (Simple File Format Family) is a family of file format specifications. These file formats all follow a similar scheme and the same principles.

# Principles
SF3 formats follow these principles:

* *No Versioning* These formats explicitly do not include any versioning at all. The way they are described in this document is final and will not change. This means the formats are eternally forwards and backwards compatible.
* *No Extensibility* There are no vendor extensibility blocks or other parts that could be added by third parties. This ensures that a consumer of these formats will always be able to read the full file and know what every single bit in it means.
* *No Optional Blocks* There are no optional blocks or parts in the formats that could be omitted. This means there is no conditional parsing needed and the structure of the files is always clear.
* *Similar Layout* Each format in the family follows a very similar format of identifier, header, and payload. This ensures that the files remain easy to parse, understand, and debug.

# Specification Description
The format specifications in this document use a BNF-style abstract syntax language. The language is defined here:

```BNF
Definition  ::= name '::=' Composition* '\n'
Composition ::= (Rule | OctetArray | Octet) (' ' (Rule | OctetArray))*
Rule        ::= name
OctetArray  ::= '[' (octet | ascii) (' ' (octet | ascii))* ']'

name        --- The name of a rule as sequence of ASCII characters.
octet       --- Eight bits expressed as two hexadecimal digits.
ascii       --- Eight bits expressed as an ASCII character whose codepoint is the octet value.
```

White space unless otherwise mandated may be inserted liberally to aid readability.

# Formats
Each format is made up of the following structure:

```
File       ::= Identifier Header Payload
Identifier ::= [ 81 S F 3 00 E0 D0 0D 0A 0A ] Format-ID
```

The rationale for the ten octets in the identifier is as follows:

* `81` An octet to stop byte-peekers from determining text. The octet lies in the undefined ranges of ASCII, ISO-8859-1, Windows-1252, and SJIS.
* `SF3` ASCII identifier for human-readability.
* `00` A null octet to stop C-string utilities from trying to munch the rest of the file.
* `E0D0` An invalid UTF-8 octet sequence to hard-crash text readers.
* `0D0A0A` A CRLFLF sequence to catch bad line conversion utilities.

The `Header`, `Payload` and `Format-ID` will be described by the individual formats.

## archive
## audio
## image
## model
## text

# File Recommendations
These formats can be delivered as part of a binary stream or deposited in a file system. The following are recommendation for metadata identifiers to distinguish SF3 data without having to parse it.

## Mime-Type
The mime-types for SF3 files should be as follows, according to the format used:

* *Archive* `application/x-sf3-archive`
* *Audio* `audio/x-sf3`
* *Image* `image/x-sf3`
* *Model* `model/x-sf3`
* *Text* `text/x-sf3`

If a general SF3 file should be designated, the mime-type should be `application/x-sf3`.

## File Extension
The file extension should always end with `.sf3`. Specifically, for the formats the following extended extensions may be used:

* *Archive* `.ar.sf3`
* *Audio* `.au.sf3`
* *Image* `.img.sf3`
* *Model* `.mod.sf3`
* *Text* `.txt.sf3`

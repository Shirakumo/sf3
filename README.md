# About SF3
SF3 (Simple File Format Family) is a family of file format specifications. These file formats all follow a similar scheme and the same principles.

# Principles
SF3 formats follow these principles:

* *No versioning* These formats explicitly do not include any versioning at all. The way they are described in this document is final and will not change. This means the formats are eternally forwards and backwards compatible.
* *No extensibility* There are no vendor extensibility blocks or other parts that could be added by third parties. This ensures that a consumer of these formats will always be able to read the full file and know what every single bit in it means.
* *No optional blocks* There are no optional blocks or parts in the formats that could be omitted. This means there is no conditional parsing needed and the structure of the files is always clear.
* *Only raw data* The data is not compressed, encrypted, or otherwise transformed. Data is always raw. If encryption or compression is desired, the entire file can instead be wrapped in a compression or encryption stream (gzip, lzma, etc).
* *Always little-endian* The formats are always little-endian wherever byte order matters. This is compatible with the vast majority of processors and software today and means no byte rearrangement is necessary when loading to memory.
* *Similar layout* Each format in the family follows a very similar format of identifier, header, and payload. This ensures that the files remain easy to parse, understand, and debug.

# Specification Description
The format specifications in this document use a BNF-style abstract syntax language. The language is defined here:

```BNF
Format      ::= (Definition | Description)*
Definition  ::= Rule '::=' Sequence '\n'
Description ::= Rule '---' text
Sequence    ::= Composition (' ' Composition)*
Composition ::= (Rule | OctetArray | Octet | Type | '(' Sequence ')') (OneOrMore | AnyNumber | ExactNumber)?
OctetArray  ::= '[' (octet | ascii) (' ' (octet | ascii))* ']'
Type        ::= 'int8' | 'int16' | 'int32' | 'int64' | 'uint8' | 'uint16' | 'uint32' | 'uint64' | 'float16' | 'float32' | 'float64'
Rule        ::= name
OneOrMore   ::= '+'
AnyNumber   ::= '*'
ExactNumber ::= '{' number '}'

name        --- The name of a rule as a sequence of non-numeric ASCII characters.
octet       --- Eight bits expressed as two hexadecimal digits.
ascii       --- Eight bits expressed as an ASCII character whose codepoint is the octet value.
text        --- Human-readable textual description of the contents.
number      --- A textual description of the number of occurrences. Can make a reference to other rules, in which case the rule's content designates a runtime number.
```

White space unless otherwise mandated may be inserted liberally to aid readability. Each rule ultimately defines a sequence of octets that should be parsed.

# Formats
Each format is made up of the following structure, where a valid file must begin with the `File` rule.

```
File       ::= Identifier Header Payload
Identifier ::= [ 81 S F 3 00 E0 D0 0D 0A 0A ] format-id
format-id  --- A single octet identifying the format.
```

The rationale for the ten octets in the identifier is as follows:

* `81` An octet to stop byte-peekers from determining text. The octet lies in the undefined ranges of ASCII, ISO-8859-1, Windows-1252, and SJIS.
* `SF3` ASCII identifier for human-readability.
* `00` A null octet to stop C-string utilities from trying to munch the rest of the file.
* `E0D0` An invalid UTF-8 octet sequence to hard-crash text readers.
* `0D0A0A` A CRLFLF sequence to catch bad line conversion utilities.

The `Header` and `Payload` will be described by the individual formats. The following format mapping is used:

* `00` *Text*
* `01` *Image*
* `02` *Audio*
* `03` *Model*
* `04` *Archive*

Any other value for the `format-id` is invalid.

## Archive

## Audio

## Image

```
Header   ::= Width Height Depth channels format
Payload  ::= Layer{Depth}
Layer    ::= Row{Height}
Row      ::= Color{Width}
Color    ::= channel{channel-count}
Width    ::= uint32
Height   ::= uint32
Depth    ::= uint32
format   --- A single octet identifying the per-channel data type.
channels --- A single octet identifying the number and order of channels.
channel  --- A single-channel colour value in the format indicated by format.
channel-count --- The number of channels indicated by channels.
```

The format is identified as one of the following:

* `01` int8
* `02` int16
* `04` int32
* `08` int64
* `11` uint8
* `12` uint16
* `14` uint32
* `18` uint64
* `22` float16
* `24` float32
* `28` float64

The channels are identified as one of the following:

* `01` R
* `02` RG
* `03` RGB
* `04` RGBA
* `12` GR
* `13` BGR
* `14` ABGR
* `24` ARGB
* `34` BGRA

The payload must have exactly `Width*Height*Depth*channel-count*format-bits` number of bits.

## Model


## Text
The text format identifies the character encoding used, followed by the raw text payload. Essentially this means it is a regular "text file", but with a header that identifies the actual encoding used and thus liberates the need for encoding detecting kludges.

```
Header   ::= encoding
Payload  ::= text
encoding --- A single octet identifying a text encoding.
text     --- A sequence of octets in the encoding described by the header.
```

The following encodings are recognised:

* `00` US-ASCII
* `10` UTF-8
* `11` UTF-16
* `12` UTF-32
* `20` ISO 8859-1
* `21` ISO 8859-2
* `22` ISO 8859-3
* `23` ISO 8859-4
* `24` ISO 8859-5
* `25` ISO 8859-6
* `26` ISO 8859-7
* `27` ISO 8859-8
* `28` ISO 8859-9
* `29` ISO 8859-10
* `2A` ISO 8859-11
* `2B` ISO 8859-12
* `2C` ISO 8859-13
* `2D` ISO 8859-14
* `2E` ISO 8859-15
* `2F` ISO 8859-16
* `30` Windows-874
* `31` Windows-1250
* `32` Windows-1251
* `33` Windows-1252
* `34` Windows-1253
* `35` Windows-1254
* `36` Windows-1255
* `37` Windows-1256
* `40` EUC-CN
* `41` EUC-JP
* `42` EUC-KR
* `43` EUC-TW
* `F0` Shift JIS
* `F1` Big5
* `F2` GBK

Any other value for the `encoding` is invalid.

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

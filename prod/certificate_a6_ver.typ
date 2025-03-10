#import "@preview/cades:0.3.0": qr-code

#set page(
  paper: "a6",
  margin: auto,
  flipped: false,
)

#set text(font: "Arial", size: 10pt)

#let csv_file = "../output/output.csv"

#let rows = csv(csv_file)

#let batch_size = (1, 20)

#let ids = rows.slice(batch_size.at(0), batch_size.at(1)).map((row)=>{
  row.at(0).trim()
})

#let certificates = rows.slice(batch_size.at(0), batch_size.at(1)).map((row)=>{
  text(row.at(8).trim())
})

#let titles = rows.slice(batch_size.at(0), batch_size.at(1)).map((row)=>{
  text(row.at(1).trim())
})

#for i in range(0, certificates.len()){
  let qr_url = "https://totemiq.com/certificate/" + ids.at(i)

  heading(titles.at(i))
  pad(certificates.at(i), top: 1em)
  // qr-code(qr_url, width: 2cm)
  align(
    end + bottom,
    qr-code("hello", width: 2cm)
  )
  pagebreak()
}



//   align(center)[
//   stack(
//     dir: ttb,
//     spacing: 1em,
//     // align: center,
//     [
//       #text(
//         size: 1.5em,
//         weight: "bold",
//         [Certificado de Identidad de Obra de Arte / Certificate of Artwork Identity]
//       )
//     ],

//     rect(width: 80%, height: 0.1em, fill: black),

//     [
//       #align(start)[
//         stack(dir: ltr, spacing: 0.5em, align: baseline,
//           [#text(weight: "bold", [Título de la Obra / Title of the Artwork:])],
//           [ ]
//         )
//       ]
//       #text(size: 1.2em, [Título de la pieza / Artwork Title])
//     ],

//     [
//       #align(start)[
//         stack(dir: ltr, spacing: 0.5em, align: baseline,
//           [#text(weight: "bold", [Técnica / Technique:])],
//           [ ]
//         )
//       ]
//       #text([impresión de alta calidad sobre papel Modigliani de 260g, libre de ácido con certificado FSC / high-quality print on 260g Modigliani paper, acid-free with FSC certification.])
//     ],

//     rect(width: 80%, height: 0.1em, fill: black),

//     [
//       #align(center)[
//         text(
//           size: 1em,
//           style: "italic",
//           [🧬 Este código es la huella digital de la pieza. Generado con tecnología UUIDv7, lo hace único, irrepetible y trazable en el tiempo.🧬 This code is the digital fingerprint of the piece. Generated with UUIDv7 technology, it makes it unique, unrepeatable, and traceable over time:]
//         )
//       ]
//     ],

//     [
//       #align(start)[
//         stack(dir: ltr, spacing: 0.5em, align: baseline,
//           [#text(weight: "bold", [Código de Identidad Único (UUIDv7) / Unique Identity Code (UUIDv7):])],
//           [ ]
//         )
//       ]
//       #text(size: 1.2em, [Código único / Unique Code])
//     ],

//     rect(width: 80%, height: 0.1em, fill: black),

//     [
//       #align(start)[
//         #stack(dir: ltr, spacing: 0.5em,
//           [#text(weight: "bold", [📍 Escanéalo (código QR) / Scan or enter it at (QR Code):])],
//           [ ]
//         )
//       ]
//         [✔ Ficha técnica completa: materiales, dimensiones y contexto cultural.✔ Complete technical sheet: materials, dimensions, and cultural context.],
//         [✔ Autenticidad y origen.✔ Authenticity and origin],
//         [✔ Registro con información adicional y trazabilidad de la obra a lo largo del tiempo.✔ Record with additional information and artwork traceability over time.]
//     ],
//     rect(width: 80%, height: 0.1em, fill: black),
//      [
//       #align(end)[
//         #stack(
//           dir: ttb,
//           spacing: 0.2em,
//           [#text(size: 0.8em, [📍 Cusco - Perú])],
//           [#line(length: 8em)],
//           [#text(size: 0.8em, [✍ Firma / Signature: Firma del artista  / Artist signature])],
//           [#pad(y:0.5em, [#text(size: 0.8em, [🔖 Sello oficial de Totemiq / Official Totemiq Seal])])],
//         )
//       ]
//     ]
//   )
// ]
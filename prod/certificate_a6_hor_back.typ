// #import "@preview/tiaoma:0.3.0"

#set page(
  paper: "a6",
  margin: .82cm,
  flipped: true,
)

#set text(font: "Arial", size: 8pt)

#let csv_file = "../output/output.csv"

#let rows = csv(csv_file)

#let batch_size = (1, rows.len())
// #let batch_size = (1, 10)

#let ids = rows.slice(batch_size.at(0), batch_size.at(1)).map((row)=>{
  row.at(0).trim()
})

#let certificates_es = rows.slice(batch_size.at(0), batch_size.at(1)).map((row)=>{
  text(row.at(8).trim())
})

#let certificates_en = rows.slice(batch_size.at(0), batch_size.at(1)).map((row)=>{
  text(row.at(9).trim())
})

#let titles = rows.slice(batch_size.at(0), batch_size.at(1)).map((row)=>{
  text(row.at(1).trim())
})

#for i in range(0, certificates_es.len()) {
  let qr_url = "https://totemiq.com/certificate/" + ids.at(i)

  heading(titles.at(i))
  pad(top: 1em)[
    #certificates_es.at(i)

    *Escanea el QR del Certificado de Identidad para acceder a más información sobre la obra, su concepto y trazabilidad.*
  ]
  
  line(length: 100%)

  // heading(titles.at(i))
  pad(top: 0.2em)[
    #certificates_en.at(i)

    *Scan the QR code on the Certificate of Identity for detailed information on the artwork’s concept and provenance.*
  ]

  align(
    end + bottom,
  )[
    // #text(qr_url, style: "italic"),d
    // #qr-code("qr_url", width: 2cm)
    
  ]
  pagebreak()
}

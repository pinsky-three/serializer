#import "@preview/cades:0.3.0": qr-code

#set page(
  paper: "a6",
  margin: .82cm,
  flipped: true,
)

#set text(font: "Arial", size: 8pt)

#let csv_file = "../output/output.csv"

#let rows = csv(csv_file)

#let batch_size = (1, 10)

#let ids = rows.slice(batch_size.at(0), batch_size.at(1)).map((row)=>{
  row.at(0).trim()
})

#let certificates = rows.slice(batch_size.at(0), batch_size.at(1)).map((row)=>{
  text(row.at(8).trim())
})

#let titles = rows.slice(batch_size.at(0), batch_size.at(1)).map((row)=>{
  text(row.at(1).trim())
})

#for i in range(0, certificates.len()) {
  let qr_url = "https://totemiq.com/certificate/" + ids.at(i)

  heading("Certificado de Identidad de Obra de Arte")
  pad(top: .5em)[
    #list(
      spacing: 0.5em,
      body-indent: .6em,
      [*Título:* #text(titles.at(i))],
      [*Técnica:* #text("Impresión de alta calidad sobre papel Modigliani de 260g, libre de ácido con certificación FSC.")],
      [*Código de Identidad Único:* #text(ids.at(i))],
    )
  ]

  [El Código de Identidad Único es la huella digital de la pieza. Generado con tecnología UUIDv7, lo hace único, irrepetible y trazable en el tiempo.]

  line(length: 100%)

  heading("Certificate of Artwork Identity")
  pad(top: .5em)[
    #list(
      spacing: 0.5em,
      body-indent: .6em,
      [*Title:* #text(titles.at(i))],
      [*Technique:* #text("High-quality print on 260g Modigliani paper, acid-free with FSC certification.")],
      [*Unique Identity Code:* #text(ids.at(i))],
    )
  ]

  [This code serves as the digital fingerprint of the piece. Generated using UUIDv7 technology, it ensures its uniqueness, non-reproducibility, and traceability over time.]
  
  align(end+bottom, 
    stack(
      dir: ltr, 
      // spacing: 8.2cm,
      stack(
        dir: ttb,
        qr-code(qr_url, width: 2cm),
        // pad(top: 1em)[
        //   // te
        // ]
      ),
      h(1fr),
      context {
        stack(
          dir: ltr,
          spacing: 1em,
          image("assets/signature.png", width: page.width*0.11),
          image("assets/totemiq_signature.svg", width: page.width*0.12),
        )
      },
    )
  ) 
  
  pagebreak()
}
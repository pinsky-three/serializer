#import "@preview/tiaoma:0.3.0"

#set page(
  paper: "a6",
  margin: .82cm,
  flipped: true,
)

#set text(font: "Poppins", size: 7pt)

#let csv_file = "../output/output.csv"

#let rows = csv(csv_file)

#let batch_size = (1, rows.len())
// #let batch_size = (1, 10)

#let ids = rows.slice(batch_size.at(0), batch_size.at(1)).map((row)=>{
  row.at(0).trim()
})


#let titles = rows.slice(batch_size.at(0), batch_size.at(1)).map((row)=>{
  text(row.at(1).trim())
})

#let technique_es = rows.slice(batch_size.at(0), batch_size.at(1)).map((row)=>{
  text(row.at(7).trim())
})

#let technique_en = rows.slice(batch_size.at(0), batch_size.at(1)).map((row)=>{
  text(row.at(8).trim())
})

#for i in range(0, ids.len()) {
  let qr_url = "https://totemiq.art/certificate/" + ids.at(i)
  
  heading("Certificado de Identidad de Obra de Arte")
  
  pad(top: .5em)[
    #list(
      spacing: 0.5em,
      body-indent: .6em,
      [*Título:* #text(titles.at(i))],
      [*Técnica:* #text(technique_es.at(i))],
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
      [*Technique:* #text(technique_en.at(i))],
      [*Unique Identity Code:* #text(ids.at(i))],
    )
  ]

  [This code serves as the digital fingerprint of the piece. Generated using UUIDv7 technology, it ensures its uniqueness, non-reproducibility, and traceability over time.]
  
  align(end+bottom, 
    stack(
      dir: ltr, 
      // spacing: 8.2cm,
      rect(
        // dir: ltr,
        width: 6.5cm,
        stroke: 0.0cm,
        // pad(top: 0em)[
        //   Escanea este codigo para acceder al registro con información adicional y trazabilidad de la obra a lo largo del tiempo.
        // ],
      )[
        #stack(dir: ltr, spacing: 1fr, 
          tiaoma.qrcode(qr_url, width: 2cm),
          // rect(width: 100%)[
          stack(dir: ttb,
            rect(width: 3.8cm, stroke: 0.0cm)[
              #align(left, 
                text("Escanea este codigo para acceder al registro con información adicional y trazabilidad de la obra a lo largo del tiempo.", size: 5pt, )
              )
            ],
            // line(length: 100%),
            rect(width: 3.8cm, stroke: 0.0cm)[
              #align(left, 
                text("Scan the QR code to access to the record with additional information and artwork traceability over time.", size: 5pt, )
              )
            ]
          )
          // ]
        )
      ],
      h(1fr),
      rect(
        stroke: 0.0cm,
      )[
        #pad(right: 0.3em)[
          #image("assets/cc.logo.large.png", width: 1.2cm)
        ]
      ],
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
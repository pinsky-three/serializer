#import "@preview/tiaoma:0.3.0"

#set page(
  margin: (x: 0.5cm, y: 1cm),
  paper: "a6",
  flipped: true,
  fill: gray.lighten(60%)
)

#set text(font: "Poppins")

#let csv_file = "../output/output.csv"

#let rows = csv(csv_file)
#let image_multiplier = 100%;

#let artwork =  rows.slice(1).filter(el => el.at(4) == "A6").map((row)=> {
  // let id = row.at(0);
  let title = row.at(1);
  let description_es = row.at(8);
  let description_en = row.at(9);
  let qr_link = row.at(10);

  // let qr_url = "https://ar.totemiq.art/" + row.at(0);

  rect(
      width: 100%,
      height: 100%,
      inset: 0cm,
      stroke: 0.0cm,
    )[
      #align()[
        #stack( 
          dir: ttb,
          align(
            horizon,
            stack(
              dir: ltr,
              text(upper(title), size: 13pt, fill: gray.darken(45%), weight: 700),      
              h(1fr),
              image("assets/totemiq_black_2.svg", width: 0.9cm)
            )
          ),
          pad(
            top: 0.3cm,
            grid(
              columns: (1fr, auto, 1fr),
              align: horizon,
              stack(
                spacing: 0.5cm,
                text(description_es, size: 7pt, fill: gray.darken(45%), weight: 400),
                text(description_en, size: 7pt, fill: gray.darken(45%), weight: 400)
              ),
              pad(
                x: 0.5cm, 
                line(start: (0%, 5%), end: (0%, 100%), stroke: 0.01cm)
              ),
              stack(
                spacing: 0.5cm,
                v(1fr),
                stack(
                  spacing: 0.5cm,
                  line(length: 100%, stroke: 0.01cm),
                  line(length: 100%, stroke: 0.01cm),
                  line(length: 100%, stroke: 0.01cm),
                  line(length: 100%, stroke: 0.01cm),
                  line(length: 100%, stroke: 0.01cm),
                  line(length: 100%, stroke: 0.01cm),
                  line(length: 100%, stroke: 0.01cm),
                  line(length: 100%, stroke: 0.01cm),
                  line(length: 100%, stroke: 0.01cm),
                ),
                v(1fr),
                stack(dir: ltr, spacing: 5pt, 
                  tiaoma.qrcode(qr_link, width: 2cm),
                  stack(dir: ttb,
                    rect(width: 3.8cm, stroke: 0.0cm)[
                      #align(left, 
                        text("Para interactuar con la pieza en realidad aumentada o conocer más sobre el proyecto y la trazabilidad de esta obra, escanea este código.", size: 5pt)
                      )
                    ],
                    rect(width: 3.8cm, stroke: 0.0cm)[
                      #align(left, 
                        text("To interact with the piece in augmented reality or learn more about the project and the traceability of this artwork, scan this code.", size: 5pt)
                      )
                    ]
                  )
                )
              )
            )
          )
          //   #image(row.at(3), width: image_multiplier, fit: "cover")
          // ],
          // pad(x: .2cm, top: -1.8cm)[
          //   #rect(width: 100%, stroke: 0.0cm, inset: .2cm, )[
          //     #align(end + horizon)[
          //       #stack(
          //         dir: ltr,
          //         // align(start + horizon)[
          //         //   #text(row.at(0), 
          //         //     fill: white, 
          //         //     size: 0.32cm,
          //         //   )
          //         // ],
          //         // context {
          //         //   stack(
          //         //     dir: ttb,
          //         //     spacing: 0.05cm,
          //         //     image("assets/signature.png", width: page.width*0.07),
          //         //     image("assets/totemiq_signature_white.svg", width: page.width*0.07),
          //         //   )
          //         // }
                  
          //       )
          //     ]
          //   ]
          // ]
        )
      ]
    ]
  })

#stack(
  dir: ttb,
  ..artwork
)
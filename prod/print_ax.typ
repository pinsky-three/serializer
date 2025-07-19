#let material = sys.inputs.at("material", default: "modigliani_260g")
#let orientation = sys.inputs.at("orientation", default: "horizontal")
#let paper_size = sys.inputs.at("paper_size", default: "a6")

#set text(font: "Poppins")

#let flipped = if orientation == "horizontal" { true } else { false }

#set page(
  margin: (x: 0cm, y: 0cm),

  paper: lower(paper_size),
  flipped: flipped,
)

#let csv_file = "../output/output.csv"

#let rows = csv(csv_file)
#let image_width = state("i_width", 0pt)
#let image_multiplier = if paper_size == "a6" { 100% } else if paper_size == "a5" {
  if orientation == "horizontal" { 90% } else { 90% }
} else if paper_size == "a4" { if orientation == "horizontal" { 90% } else { 90% } } else { 85% };

#let artwork = (
  rows
    .slice(1)
    .filter(el => (
      lower(el.at(6)) == lower(orientation)
        and lower(el.at(4)) == lower(paper_size)
        and lower(el.at(5)) == lower(material)
    ))
    .map(row => {
      if paper_size == "a6" {
        rect(
          width: 101%,
          height: 101%,
          inset: 0cm,
          stroke: none,
        )[
          #align(center)[
            #image(row.at(3), width: image_multiplier, fit: "cover") // <image>
          ]
        ]
      } else {
        rect(
          width: 100%,
          height: 100%,
          inset: 0cm,
          stroke: none,
        )[
          #align(center + bottom)[
            #stack(
              dir: ttb,
              rect(stroke: 0.0cm, inset: 0cm)[
                #image(row.at(3), width: image_multiplier, fit: "contain") // <image>
              ],
              pad(
                x: (100% - image_multiplier) / 2,
                top: if orientation == "horizontal" { 0.2cm } else { 0.25cm },
                bottom: 0.2cm,
              )[
                #rect(width: 100%, stroke: 0.0cm, inset: .0cm, fill: white)[
                  #align(end + horizon)[
                    #stack(
                      dir: ltr,
                      align(start + horizon)[
                        #text(row.at(0), fill: gray.lighten(50%), size: if paper_size == "a5" { 6pt } else { 8pt })
                      ],
                      context {
                        stack(
                          dir: ltr,
                          spacing: 0.3cm,
                          image("assets/signature.png", width: if (orientation == "horizontal") {
                            page.width * 0.05
                          } else { page.width * 0.07 }),
                          image("assets/totemiq_signature.svg", width: if (orientation == "horizontal") {
                            page.width * 0.05
                          } else {
                            page.width * 0.07
                          }),
                        )
                      },
                    )
                  ]
                ]
              ],
            )
          ]
        ]
      }
    })
)

#stack(
  dir: ttb,
  ..artwork,
)

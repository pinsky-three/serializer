#set page(
  margin: (x: 0cm, y: 0cm),
  
  paper: "a5",
  flipped: false,
)

#let csv_file = "../output/output.csv"

#let rows = csv(csv_file)
#let image_width = state("i_width", 0pt)
#let image_multiplier = 85%;

#let artwork =  rows.slice(1).filter(el => el.at(5) == "vertical" and el.at(4) == "A5").map((row)=> {
    rect(
        width: 100%,
        height: 100%,
        inset: 0cm,
      )[
        #align(center + horizon)[
          #stack( 
            dir: ttb,
            rect(stroke: 0.0cm, inset: 0cm)[
                #image(row.at(3), width: image_multiplier, fit: "contain") // <image>
            ],
            pad(x: (100%-image_multiplier)/2, top: 0.3cm)[
              #rect(width: 100%, stroke: 0.0cm, inset: .2cm, fill: white)[
                #align(end + horizon)[
                  #stack(
                    dir: ltr,
                    align(start + horizon)[
                      #text(row.at(0), 
                        fill: gray, 
                        size: 0.32cm,
                      )
                    ],
                    context {
                      stack(
                        dir: ltr,
                        spacing: 0.05cm,
                        image("assets/signature.png", width: page.width*0.07),
                        image("assets/totemiq_signature.svg", width: page.width*0.07),
                      )
                    }
                  )
                ]
              ]
            ]
          )
        ]
      ]
  })

#stack(
  dir: ttb,
  ..artwork
)
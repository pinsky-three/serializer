#set page(
  margin: (x: 0cm, y: 0cm),
  
  paper: "a6",
  flipped: true,
)

#let csv_file = "../output/output.csv"

#let rows = csv(csv_file)
#let image_multiplier = 100%;

#let artwork =  rows.slice(1).filter(el => el.at(5) == "horizontal" and el.at(4) == "A6").map((row)=> {
    rect(
        width: 100%,
        height: 100%,
        inset: 0cm,
      )[
        #align(center)[
          #stack( 
            dir: ttb,
            rect(stroke: 0.0cm, inset: 0cm)[
              #image(row.at(3), width: image_multiplier, fit: "cover")
            ],
            pad(x: .2cm, top: -1.8cm)[
              #rect(width: 100%, stroke: 0.0cm, inset: .2cm, )[
                #align(end + horizon)[
                  #stack(
                    dir: ltr,
                    // align(start + horizon)[
                    //   #text(row.at(0), 
                    //     fill: white, 
                    //     size: 0.32cm,
                    //   )
                    // ],
                    // context {
                    //   stack(
                    //     dir: ttb,
                    //     spacing: 0.05cm,
                    //     image("assets/signature.png", width: page.width*0.07),
                    //     image("assets/totemiq_signature_white.svg", width: page.width*0.07),
                    //   )
                    // }
                    
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
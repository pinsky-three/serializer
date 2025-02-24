#set page(
  margin: (x: 0cm, y: 0cm),
  paper: "a3",
  flipped: false,
)


#let csv_file = "../output/output.csv"

#let rows = csv(csv_file)
#let image_width = state("i_width", 0pt)
#let image_multiplier = 92%;

#let items = rows.slice(1).filter(el => el.at(4) == "vertical").chunks(4).map((chunk)=> {
  let artwork =  chunk.map((row)=> {
    rect(
      width: 100%,
      height: 100% / 2,
      inset: 0cm,
    )[
      #align(center + top)[
        #stack( 
          dir: ttb,
          pad(top: 0.7cm, bottom: 0cm)[
            #rect(stroke: 0.00cm)[
              #image(row.at(3), width: image_multiplier, fit: "contain") // <image>
            ]
          ],
          pad(x: (100%-image_multiplier)/2, top: -.4cm)[
            #rect(width: 100%, stroke: 0.00cm, inset: 0cm)[
              #align(end + horizon)[
                #stack(
                  dir: ltr,
                  spacing: 0.4cm,
                  align(start + horizon)[
                    #text(row.at(0), 
                      fill: gray, 
                      size: 0.2cm,
                    )
                  ],
                  stack(
                    dir: ttb,
                    image("assets/signature.png", width: 1.0cm),
                      // text("2025", font: "Petit Formal Script", size: 0.1cm, weight: "bold"),
                  ),
                  image("assets/totemiq_signature.svg", width: 1.1cm),
                )
              ]
            ]
          ]
        )
        
      ]
    ]
  })

  grid(
    columns: 2,
    ..artwork
  )
})

#stack(
  dir: ttb,
  ..items
)
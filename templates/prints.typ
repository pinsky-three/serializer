


#set page(
  margin: (x: 0cm, y: 0cm),
  paper: "a3",
  flipped: true,
)

// #let n = 10;

#let image_path = "assets/print_2.png"


#let vertical_items = range(4).map((i)=> {
    rect(
        width: 100%,
        height: 100% / 2,        
        inset: 0cm,
    )[
        #align(center + top)[
          #pad(top: 0.7cm, bottom: 0cm)[
            #image(image_path, width: 85%, fit: "contain")
          ]
          
          #pad(left: 1.58cm, right: 1.58cm, top: -.2cm)[
            #rect(width: 100%, stroke: 0.00cm, inset: 0cm)[
              #align(end + horizon)[
                #stack(
                  dir: ltr,
                  spacing: 0.4cm,
                  align(start + horizon)[
                    #text("01951afb-3e41-7449-bf7d-b3218cc9e32f", 
                      fill: gray, 
                      size: 0.2cm, font: "Petit Formal Script")
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
        ]
    ]
})

#grid(
    columns: 2,
    ..vertical_items
)

// #set page(
//   margin: (x: 0cm, y: 0cm),
//   paper: "a3",
//   // flipped: true,
// )
// #pagebreak()
#set page(
  margin: (x: 0cm, y: 0cm),
  paper: "a6",
  flipped: false,
  number-align: center,
)

#let csv_file = "../output/output.csv"

#let rows = csv(csv_file)

#let artwork = rows.slice(1).filter(el => el.at(4) == "A6").map((row)=> {
  let rotation = if row.at(6) == "horizontal" {90deg} else {0deg}
  
  align(
    center + horizon,
    rect(width: 101%, height: 101%, inset: 0cm, stroke: none)[
      #rotate(rotation, reflow: true)[
        #image(row.at(3), width: 100%, height: 100%, fit: "cover")
      ]
    ]
  )
})

#for art in artwork [
  #art
]
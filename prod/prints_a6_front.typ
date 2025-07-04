#set page(
  margin: (x: 0cm, y: 0cm),
  paper: "a6",
  flipped: false,
)

#let csv_file = "../output/output.csv"

#let rows = csv(csv_file)

#let artwork = rows.slice(1).filter(el => el.at(4) == "A6").map((row)=> {
  let rotation = if row.at(5) == "horizontal" {90deg} else {0deg}

  rotate(rotation, reflow: true)[
    #image(row.at(3), width: 100%, fit: "cover")
  ]
})

#stack(
  dir: ttb,
  ..artwork
)
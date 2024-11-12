#let results = csv("data/qr_cta.csv")

#set page(margin: (x: 1cm, y: 1cm))


#let n = 10;

#let vertical_items = results.filter((r)=>not(r.at(0).contains("_inst"))).map((r)=> {
  range(n).map((i)=> {
    rect(
        width: 100%, 
        [
          #image(width: 100%, r.first())
        ]
    )
  })
}).flatten()

#let horizontal_items = results.filter((r)=>r.at(0).contains("_inst")).map((r)=> {
  range(n).map((i)=> {
    rect(
        width: 100%, 
        [
          #image(width: 100%, r.first())
        ]
    )
  })
}).flatten()

#grid(
    columns: 5,
    ..vertical_items
)

#grid(
    columns: 3,
    ..horizontal_items
)


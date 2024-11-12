#import "@preview/cades:0.3.0": qr-code
#import "@preview/suiji:0.3.0": *

#set page(margin: (x: 1cm, y: 1cm))

#let results = csv("./data/totemiq_inventory_a4.csv")
#let results = results.slice(1)

#let seq = "abcdefghijklmnopqrstuvwxyz0123456789".split("").slice(1, 38).map(it => raw(it))
#let rng = gen-rng(1728097114550)

#let choices = ()
#let codes = ()

#let results = results.filter((row)=>row.at(2).len() > 0). map((row) => {
    let design_name = lower(row.at(0))
    design_name = design_name.replace(" ", "-")

    let product_name = lower(row.at(1))
    let total_copies = int(row.at(2))

    (
        design_name: design_name,
        product_name: product_name,
        total_copies: total_copies
    )
})

#for r in results {
    for i in range(r.total_copies) {
        (rng, choices) = choice(rng, seq, size: 16)
        
        let uuid = choices.map(it => it.text).join("")

        codes.push((
            uuid: uuid,
            design_name: r.design_name,
            product_name: r.product_name
        ))
    }
}

#let generate_items = codes.map((code) => {
    let qr_url = "https://totemiq.art/product/" + code.uuid

    let product_prefix = code.product_name
    let product_design = code.design_name

    let price_pen = 310
    let price_usd = 83

    rect(
        width: 6cm, 
        height: auto, 
        inset: 10pt,
        [
            #set align(center)
            #qr-code(qr_url, width: 3cm)
            #code.uuid\-#product_prefix\-#product_design

            #rect(
                stroke: rgb("e4e5ea"),
                inset: 4pt,
                width: auto,
                height: auto,
                [
                    Price (USD): \$#price_usd
                    
                    Precio (PEN): S/#price_pen
                ]
            )
        ]
    )
})


#grid(
    columns: 3,
    ..generate_items
)
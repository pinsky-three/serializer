#import "@preview/cades:0.3.0": qr-code
#import "@preview/suiji:0.3.0": *


#let product_prefix = "pri-a5-fab"
#let product_design = "mestiza-de-ollantaytambo"

// #let uuid = "c92054d1dd6"
#let timestamp = datetime.today()

#let price_pen = 180
#let price_usd = 48

#let rng = gen-rng(42)

#let seq = "abcdefghijklmnopqrstuvwxyz0123456789".split("").slice(1, 38).map(it => raw(it))

#let choices = []

#grid(
    columns: 2,
    for i in range(10) {
        (rng, choices) = choice(rng, seq, size: 16)
        let uuid = choices.map(it => it.text).join("")
        let qr_url = "https://totemiq.art/product/" + uuid


        rect(
            width: auto, 
            height: auto, 
            inset: 8pt,
            [
                #set align(center)
                // #image("./assets/totemiq_logo_mono.png", height: 1.2cm)

                #qr-code(qr_url, width: 3cm)
                #product_prefix\-#product_design

                #uuid

                #rect(
                    stroke: rgb("e4e5ea"),
                    [
                        Price (USD): \$#price_usd

                        Precio (PEN): S/#price_pen

                    ]
                )
            ]
        )

    }
)



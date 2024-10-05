#import "@preview/cades:0.3.0": qr-code


#let product_prefix = "pri-a5-fab"
#let product_design = "mestiza-de-ollantaytambo"

#let uuid = "c92054d1dd6"
#let timestamp = datetime.today()

#let price_pen = 180
#let price_usd = 48

#rect(
    width: auto, 
    height: auto, 
    inset: 8pt,
    [
        #set align(center)
        // #image("./assets/totemiq_logo_mono.png", height: 1.2cm)

        #qr-code("https://totemiq.art/product/" + uuid, width: 3cm)
        #product_prefix\-#product_design

        #uuid

        #rect(
            stroke: rgb("e4e5ea"),

            //fill: rgb("e4e5ea"),
            [
                Price (USD): \$#price_usd

                Precio (PEN): S/#price_pen
            ]
        )
    ]
)



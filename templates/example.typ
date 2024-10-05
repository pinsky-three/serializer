#import "@preview/cades:0.3.0": qr-code
#import "@preview/suiji:0.3.0": *

#let product_prefix = "pri-a5-fab"
#let product_design = "mestiza-de-ollantaytambo-fasd-f-asd-f-asdf-asdfasdf-asdfasd"
#let timestamp = datetime.today()

#let price_pen = 180
#let price_usd = 48

#let seq = "abcdefghijklmnopqrstuvwxyz0123456789".split("").slice(1, 38).map(it => raw(it))

#let rng = gen-rng(42)
#let choices = ()

#let codes = ()

#set page(margin: (x: 1cm, y: 1cm))

#for i in range(12) {
    (rng, choices) = choice(rng, seq, size: 16)

    let uuid = choices.map(it => it.text).join("")

    codes.push(uuid)
}


// Función para generar una lista de rectángulos con códigos QR
#let generate_items = codes.map((uuid) => {
    // Generar UUID aleatorio
    

    
    let qr_url = "https://totemiq.art/product/" + uuid

    // Crear un rectángulo con el contenido
    rect(
        width: 6cm, 
        height: auto, 
        inset: 10pt,
        [
            #set align(center)
            #qr-code(qr_url, width: 3cm)
            #uuid\-#product_prefix\-#product_design

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
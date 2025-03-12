#import "@preview/cades:0.3.0": qr-code

#set page(
  paper: "a6",
  margin: auto,
  flipped: true,
)

#set text(font: "Arial", size: 9pt)

#let csv_file = "../output/output.csv"

#let rows = csv(csv_file)

#let batch_size = (1, 10)

#let ids = rows.slice(batch_size.at(0), batch_size.at(1)).map((row)=>{
  row.at(0).trim()
})

#let certificates = rows.slice(batch_size.at(0), batch_size.at(1)).map((row)=>{
  text(row.at(8).trim())
})

#let titles = rows.slice(batch_size.at(0), batch_size.at(1)).map((row)=>{
  text(row.at(1).trim())
})

#for i in range(0, certificates.len()) {
  let qr_url = "https://totemiq.com/certificate/" + ids.at(i)

  heading(titles.at(i))
  pad(certificates.at(i), top: 1em)
  // qr-code(qr_url, width: 2cm)
  align(
    end + bottom,
    qr-code(qr_url, width: 2cm)
  )
  pagebreak()
}
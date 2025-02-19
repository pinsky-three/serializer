#set page(paper: "a3", fill: black)

#let variable = "*"

#for i in range(1, 63 ) {
   rect(
    width: 1.5%*i, 
    height: 0.1cm,
    fill: gradient.linear(
      ..color.map.inferno,
      dir: rtl,
    ),
  )
}


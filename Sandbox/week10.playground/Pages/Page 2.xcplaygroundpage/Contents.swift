//: [Previous](@previous)

import Foundation

let data = ["A big fish in a little pond",
            "A barking dog never bites",
            "A good medicine tastes bitter",
            "A burnt child dreads the fire",
            "No pain No gain",
            "Walls have ears",
            "The more, the better",
            "A bad workman blames his tools",
            "A drowning man will catch at a straw",
            "Do not count your chickens before they hatch",
            "Beggars can't be choosers",
            "Between a rock and a hard place",
            "Blood is thicker than water",
            "Casting pearls before swine",
            "Charity begins at home",
            "Even Homer sometimes nods",
            "Every cloud has a silver lining"]

var count = 0

for proverb in data{
    if(proverb.contains("the")){
        count += 1
    }
}
print(count)

print("\nQ1")
let ans: Int = data.reduce(0, {$1.contains("the") == true ? $0 + 1 : $0})
print(ans == count)

/*
python's range method in AutoHotkey
    start - range's start position
    stop - range's stop position (included)
    step - range's step (difference between current and next item in list)
Usage ways:

    range(stop)
     - returns an array that contains numbers from 1 to stop with step 1 
        (or from -1 to stop with step -1 if negative number was given)

    range(start, stop)
     - return an array that contains numbers from start to stop with step 1
        (or from start to stop with step -1 if start > stop)

    range(start, stop, step)
     - returns an array that contains numbers from start to stop with custom step 
        (or from start to stop with custom step if negative number was given)

    - Works with negative step as well

Examples:
    range(10) -> [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
    range(10, 4) -> [10, 9, 8, 7, 6, 5, 4]
    range(-7) -> [-1, -2, -3, -4, -5, -6, -7]
    range(10, 4, 2) -> Incorrect step
    range(10, 3, -2) -> [10, 8, 6, 4]
*/
range(start := "null", stop := "null", step := "null") {
    if start = "null" {
        throw Error("specify at least 1 parameter")
    }
    if stop = "null" {
        stop := start
        start := start > 0 ? 1 : -1
    }
    if stop = 0 {
        throw Error("stop can't be 0")
    }
    if step = "null" {
        step := start > stop ? -1 : 1
    }
    list := []
    if stop >= start and step > 0 {
        lastnum := start
        while true {
            if lastnum <= stop {
                list.Push lastnum
                lastnum += step
            }
            else {
                break
            }
        }
    }
    else if stop <= start and step < 0 {
        lastnum := start
        while true {
            if lastnum >= stop {
                list.Push lastnum
                lastnum += step
            }
            else {
                break
            }
        }
    }
    else {
        Throw Error("Incorrect step")
    }
    return list
}

/*
works almost as python's if item in [list]
checks if item is similar to any list's item and return an object

Object's properties:
    index:     index where similar item was found
    name:      list's index value
    result:    similarity result (x/30)
    similar:     true if given item is similar to list's item

only has found property if wasn't found that is false
*/
similarIn(item, list := []) { 
    ; secret characters must be included as well
    list.Push("chancetaker", "theriftsorcerer", "thegamer")
    for i, k in list {
        a := checkSimilarity(item, k)
        if a.similar {
            return { index: i,
                name: k,
                result: a.result,
                similar: a.similar }
        }
    }
    return { similar: false }
}

; Checks if unit1 is similar to unit2
; string1 - string to check
; string2 - string to compare with
checkSimilarity(string1, string2) {
    failcounter := 0
    countercap := StrLen(string2)
    counter1 := 0
    counter2 := 0
    counter3 := 0
    list1 := StrSplit(string2)
    list2 := StrSplit(string1)
    for u, j in list1 {
        for i, k in list2 {
            if j = k {
                counter1 += 1
                break
            }
        }
    }
    for u, j in list1 {
        if (u + failcounter <= list2.Length) and (u <= list1.Length) {
            if list1[u] = list2[u + failcounter] {
                counter2 += 1
            }
            else {
                failcounter += 1
                if failcounter = 2 {
                    failcounter := 0
                }
            }
        }
    }
    for u, j in list1 {
        if (u <= list2.Length) and (u <= list1.Length) {
            if list1[u] = list2[u] {
                counter3 += 1
            }

        }
    }
    if counter1 != 0 {
        return { similar: ((counter1 / countercap * 10) + (counter2 / countercap * 10) + (counter3 / countercap * 10)) >= 20,
            result: ((counter1 / countercap * 10) + (counter2 / countercap * 10) + (counter3 / countercap * 10)) }
    }
    else {
        return { similar: 0,
            result: 0 }
    }
}
package main

import (
    "fmt"
    "os"
    "example/hello/transport"
)


func main() {
    platformId := fmt.Sprintf("NSR:Quay:%s", os.Args[1])
    summaries, err := transport.FetchTransportSummaries(platformId)

    if err != nil {
        fmt.Println(err)
    }

    for i, summary := range summaries{
        fmt.Printf("%s:%d", summary.LineName, summary.MinutesTillArrival)

        if i < len(summaries)-1 {
          fmt.Print(" ") // Print space only if it's not the last item
        }
    }
}


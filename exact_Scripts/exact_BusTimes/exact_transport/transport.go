package transport

import (
	"encoding/json"
	"fmt"
	"io"
	"net/http"
	"net/url"
	"time"
)

type TransportSummary struct {
	LineName         string `json:"line_name"`
	TimeType         string `json:"time_type"`
	MinutesTillArrival int    `json:"minutes_till_arrival"`
}

func FetchTransportSummaries(platformID string) ([]TransportSummary, error) {

    startTime := time.Now().Format(time.RFC3339)
    limit := 3
    apiURL := fmt.Sprintf("https://api.kolumbus.no/api/platforms/%s/departures", url.QueryEscape(platformID))
    reqURL := fmt.Sprintf("%s?startTime=%s&limit=%d", apiURL, url.QueryEscape(startTime), limit)

    resp, err := http.Get(reqURL)
    if err != nil {
	return nil, fmt.Errorf("error making request: %w", err)
    }
    defer resp.Body.Close()

    if resp.StatusCode != http.StatusOK {
	return nil, fmt.Errorf("received non-200 response: %d", resp.StatusCode)
    }

    body, err := io.ReadAll(resp.Body)
    if err != nil {
	return nil, fmt.Errorf("error reading response: %w", err)
    }

    type rawTransportSummary struct {
	LineName            string    `json:"line_name"`
	TimeType            string    `json:"time_type"`
	ExpectedArrivalTime time.Time `json:"expected_arrival_time"`
    }

    var rawSummaries []rawTransportSummary
    err = json.Unmarshal(body, &rawSummaries)
    if err != nil {
	return nil, fmt.Errorf("error unmarshalling response: %w", err)
    }

    currentTime := time.Now()
    var summaries []TransportSummary

    for _, raw := range rawSummaries {
	minutesTillArrival := int(raw.ExpectedArrivalTime.Sub(currentTime).Minutes())
	if minutesTillArrival > 999 || minutesTillArrival < 1 {
	    continue
	}
	summaries = append(summaries, TransportSummary{
	    LineName:         raw.LineName,
	    TimeType:         raw.TimeType,
	    MinutesTillArrival: minutesTillArrival,
	})
    }

    return summaries, nil
}


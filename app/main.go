package main

import (
  "fmt"
  "net/http"
  "log"
  "sync"
)

var mu sync.Mutex
var count int

func main() {
  http.HandleFunc("/", handler)
  http.HandleFunc("/counter", counter)
  http.HandleFunc("/reqdetails", reqdetails)
  log.Fatal(http.ListenAndServe("localhost:8080", nil))
}

func handler(w http.ResponseWriter, r *http.Request) {
  mu.Lock()
  count++
  mu.Unlock()
  fmt.Fprintf(w, "URL.Path = %q\n", r.URL.Path)
}


func counter(w http.ResponseWriter, r *http.Request) {
  mu.Lock()
  fmt.Fprintf(w, "Count: %d\n", count)
  mu.Unlock()
}

func reqdetails(w http.ResponseWriter, r *http.Request) {
  fmt.Fprintf(w, "%v", r)
}

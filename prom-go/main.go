package main

import (
	"fmt"
	"github.com/prometheus/client_golang/prometheus"
	"github.com/prometheus/client_golang/prometheus/promauto"
	"github.com/prometheus/client_golang/prometheus/promhttp"
	"log"
	"net/http"
)

func main() {
	fmt.Println("vim-go")

	counter := promauto.NewCounter(prometheus.CounterOpts{
		Name: "my_app_counter",
		Help: "My app's counter",
	})

	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		counter.Inc()

		w.WriteHeader(200)
	})
	http.Handle("/metrics", promhttp.Handler())
	log.Fatal(http.ListenAndServe(":8080", nil))
}

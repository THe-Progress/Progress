package main
//consumer.go

import (
    "encoding/json"
	"log"
	"net/http"

	"github.com/gorilla/mux"
	"github.com/streadway/amqp"
)

type data struct {
	Appname  string `json:"appname"`
	Severity int    `json:"severity"`
	Message  string `json:"message"`
}

func failOnError(err error, msg string) {
    if err != nil { 
        log.Fatalf("%s: %s", msg, err)
    }
}

//Creating the connection to Make MessageQueue

func ConnectToRabbitMQ() (*amqp.Connection, *amqp.Channel) {
    conn, err := amqp.Dial("amqp://guest:guest@localhost:5672/")
    failOnError(err, "Failed to connect to RabbitMQ")
    ch, err := conn.Channel()
    failOnError(err, "Failed to open a channel")
    return conn, ch
}






var (

	queueName   = "notification_queue"
)


//Publishing the prompt to send it into the queue using exchange 
func prompt(ch *amqp.Channel, resdata data) {
	jsonData, err := json.Marshal(resdata)
    if err != nil {
        log.Fatalf("Error converting struct to JSON: %v", err)
    }
    q, err := ch.QueueDeclare(
        queueName, // name
        false,   // durable
        false,   // delete when unused
        false,   // exclusive
        false,   // no-wait
        nil,     // arguments
    )
    failOnError(err, "Failed to declare a queue")

    err = ch.Publish(
        "",     // exchange
        q.Name, // routing key
        false,  // mandatory
        false,  // immediate
        amqp.Publishing{
            ContentType: "application/json",
            Body:        jsonData,
        })
    failOnError(err, "Failed to publish a message")
	log.Printf(" [x] Sent %s", jsonData)

}



func SatricialResponse(ch *amqp.Channel) <-chan amqp.Delivery{
   q, err := ch.QueueDeclare(
        "response_queue", // Name of the queue for responses
        false,            // Durable
        false,            // Delete when unused
        false,            // Exclusive
        false,            // No-wait
        nil,              // Arguments
    )
    failOnError(err, "Failed to declare a queue")

    msgs, err := ch.Consume(
        q.Name, // Queue name
        "",     // Consumer name
        true,   // Auto acknowledge
        false,  // Exclusive
        false,  // No local
        false,  // No wait
        nil,    // Args
    )
    failOnError(err, "Failed to register a consumer")

    return msgs
}


//Handling the response sent as json prompt 

func responserhandler(w http.ResponseWriter, r *http.Request){
   var resdata data
    decoder := json.NewDecoder(r.Body)
    err:=decoder.Decode(&resdata)
	if err!=nil {
		http.Error(w,err.Error(),http.StatusBadRequest)
		return
	}
    conn,ch :=ConnectToRabbitMQ()
	defer conn.Close()
	defer ch.Close()

    prompt( ch, resdata)
    w.WriteHeader(http.StatusOK)
    w.Write([]byte("Message sent to RabbitMQ"))



}

//Handling the response from the consumer to recieve the satricial notifications


func main() {
    // Create a new router
    r := mux.NewRouter()

    // Define the route and its handler function
    r.HandleFunc("/app/notify", responserhandler).Methods("POST")

    // Start the HTTP server
    log.Fatal(http.ListenAndServe(":8080", r))

    conn,ch:=ConnectToRabbitMQ()
	defer conn.Close()
	defer ch.Close()

	responseMsgs := SatricialResponse(ch)

    go func (){
		for d := range responseMsgs {
			log.Printf("Recieved response:%s",d.Body)
			
		}
	}()

	

}
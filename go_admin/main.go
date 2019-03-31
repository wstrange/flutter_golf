package main

import (
	"context"
	"fmt"
	"log"

	firebase "firebase.google.com/go"
)

func main() {
	// Use a service account
	//sa := option.WithCredentialsFile("../service-accounts/service-account.json")

	ctx := context.Background()
	//app, err := firebase.NewApp(ctx, nil, sa)
	app, err := firebase.NewApp(ctx, nil, nil)

	if err != nil {
		log.Fatalln(err)
	}

	client, err := app.Firestore(ctx)
	if err != nil {
		log.Fatalln(err)
	}

	dsnap, err := client.Collection("users").Doc("test-admin-1").Get(ctx)
	if err != nil {
		log.Fatalln(err)
	}
	m := dsnap.Data()
	fmt.Printf("Document data: %#v\n", m)

	courses, err := client.Collection("courses").Doc("AIJwXrIv0Q1lgefcSxbo").Get(ctx)
	if err != nil {
		log.Fatalln(err)
	}
	c := courses.Data()
	fmt.Printf("Document data: %#v\n", c)

	users := client.Collection("users")

	doc, err := users.Doc("test3").Set(ctx, map[string]interface{}{
		"_id":   "test3",
		"first": "Ada",
		"last":  "Lovelace",
		"email": "foo@bar.com",
		"born":  1815,
	})
	if err != nil {
		log.Fatalf("Failed adding alovelace: %v", err)
	}

	fmt.Printf("Doc data  %#v\n ", doc)

	d, err := users.Doc("test3").Collection("tee_times").Doc("2019-10-10-1340").Set(ctx, map[string]interface{}{
		"_id": "test3",
	})

	fmt.Printf("Doc data  %#v\n ", d)

	defer client.Close()
}

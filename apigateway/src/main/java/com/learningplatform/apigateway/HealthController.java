package com.learningplatform.apigateway;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;
import reactor.core.publisher.Mono;

@RestController
public class HealthController {

    @GetMapping("/")
    public Mono<String> health() {
        return Mono.just("API Gateway is running and connected to Eureka!");
    }
}

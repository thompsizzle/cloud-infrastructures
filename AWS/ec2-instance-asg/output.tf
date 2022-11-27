output "load_balancer_dns" {
  value = aws_lb.lb_tf.dns_name
}

docker rm -f polinx-dev || true
docker run -idt --rm -v $(pwd)/..:/src/polinx -v ~/.ssh:/root/.ssh --name polinx-dev polinx-dev
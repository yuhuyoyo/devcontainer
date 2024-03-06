FROM alpine:latest

# Copy and configure your scanner script
COPY cirro_data_scanner.sh /usr/local/bin/cirro_data_scanner.sh
RUN chmod +x /usr/local/bin/scanner_script.sh

# Define the command to run your scanner script
CMD ["/usr/local/bin/cirro_data_scanner.sh"]


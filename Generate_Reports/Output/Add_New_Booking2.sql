
PL/SQL procedure successfully completed.

************************************************************************************************
Before booking a product for a trip, the following must be done first...

1) The customer MUST already exist (Add a new customer by running the Add_New_Customer.sql script)
2) the trip MUST have already been added by running the Add_New_Trip.sql script

If BOTH the trip and customer already exist, then you can continue on
************************************************************************************************

Enter the itinerary number for the trip this product is being booked for: 1471
Enter the booking date for this product (format YYYY-MM-DD): 2021-12-16
Enter the product supplier name: Air Canada
Enter the product category ID: 150
Enter the product class code (i.e. FS for First Class, DELX for Deluxe): ECN
Enter a brief description of the product: Calgary/Vancouver/Calgary
Enter the product start date (format YYYY-MM-DD): 2021-09-20
Enter the product expiry date (format YYYY-MM-DD): 2021-10-05
Enter the Agency fee code for the product (i.e. Enter 'NC' for No Charge): NC
Enter the product price EXCLUDING tax: 438.00
Enter the total product sales tax amount: 76.00
Enter the commission amount: 0.00
Enter the payment due date (format YYYY-MM-DD): 2021-12-16
Enter the agent ID for the agent booking this trip: 102

You've entered the following information for a product booking.....
           
Itinerary No: 1471                                                              
Client: Mike Jones - 403                                                        
Booking No: 1449                                                                
Sales Date: 2021-12-16                                                          
Product Category: AIRLINES - 150                                                
Fees: NC                                                                        
Price:    $438.00                                                               
Tax:  $76.00                                                                    
Commission: 0                                                                   
Payment Due Date: 2021-12-16                                                    
Start Date: 2021-09-20                                                          
End Date: 2021-10-05                                                            
Supplier: Air Canada                                                            
Product Class: ECN                                                              
Agent ID: 102                                                                   
Product Description: Calgary/Vancouver/Calgary                                  

PL/SQL procedure successfully completed.

If the booking information is correct, press 'Y' to save. Press 'N' to exit without saving: Y

A NEW booking has been added for itinerary number #1471                        

PL/SQL procedure successfully completed.


Sequence dropped.


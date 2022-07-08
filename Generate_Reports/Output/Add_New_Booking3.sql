
PL/SQL procedure successfully completed.

************************************************************************************************
Before booking a product for a trip, the following must be done first...

1) The customer MUST already exist (Add a new customer by running the Add_New_Customer.sql script)
2) the trip MUST have already been added by running the Add_New_Trip.sql script

If BOTH the trip and customer already exist, then you can continue on
************************************************************************************************

Enter the itinerary number for the trip this product is being booked for: 1471
Enter the booking date for this product (format YYYY-MM-DD): 2021-12-16
Enter the product supplier name: Holiday Inn
Enter the product category ID: 350
Enter the product class code (i.e. FS for First Class, DELX for Deluxe): OCNVI
Enter a brief description of the product: Holiday Inn
Enter the product start date (format YYYY-MM-DD): 2021-09-20
Enter the product expiry date (format YYYY-MM-DD): 2021-09-21
Enter the Agency fee code for the product (i.e. Enter 'NC' for No Charge): NC
Enter the product price EXCLUDING tax: 250.00
Enter the total product sales tax amount: 37.50
Enter the commission amount: 25.00
Enter the payment due date (format YYYY-MM-DD): 2021-09-20
Enter the agent ID for the agent booking this trip: 102

You've entered the following information for a product booking.....
           
Itinerary No: 1471                                                              
Client: Mike Jones - 403                                                        
Booking No: 1450                                                                
Sales Date: 2021-12-16                                                          
Product Category: HOTEL REPS & CHAINS IN CANADA - 350                           
Fees: NC                                                                        
Price:    $250.00                                                               
Tax:  $37.50                                                                    
Commission: 25                                                                  
Payment Due Date: 2021-09-20                                                    
Start Date: 2021-09-20                                                          
End Date: 2021-09-21                                                            
Supplier: Holiday Inn                                                           
Product Class: OCNVI                                                            
Agent ID: 102                                                                   
Product Description: Holiday Inn                                                

PL/SQL procedure successfully completed.

If the booking information is correct, press 'Y' to save. Press 'N' to exit without saving: Y

A NEW booking has been added for itinerary number #1471                        

PL/SQL procedure successfully completed.


Sequence dropped.


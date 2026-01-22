<script runat="server">
   Platform.Load("Core", "1");
   
   /* CONFIGURATION */
   /* Replace with your Data Extension External Key */
   var deExternalKey = "profile_center_supression_de_allbrands"; 
   var subscriberKeyField = "email";
   var newStatus = "Unsubscribed";
   
   try {
       /* 1. Initialize the Data Extension */
       var unsubDE = DataExtension.Init(deExternalKey);
       var data = unsubDE.Rows.Retrieve();
   
       /* 2. Check if there are records to process */
       if (data && data.length > 0) {
           
           for (var i = 0; i < data.length; i++) {
               var sk = data[i][subscriberKeyField];
   
               if (sk) {
                   /* 3. Initialize and Update the Subscriber status */
                   var subObj = Subscriber.Init(sk);
                   var updateStatus = subObj.Update({Status: newStatus});
                   
                   /* Optional: Log result for each row */
                   Write("Processing SK: " + sk + " | Result: " + updateStatus + "<​br>");
               }
           }
           
           Write("Finished processing " + data.length + " records.");
           
       } else {
           Write("No records found in the Data Extension.");
       }
   
   } catch (err) {
       /* 4. Error handling */
       Write("Error: " + Stringify(err));
   }
</script>
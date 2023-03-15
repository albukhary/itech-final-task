import * as express from 'express';
import * as promClient from 'prom-client';
import 'express-async-errors';

const app = express();

app.get('/', (req: express.Request, res: express.Response) => {
  const response = {
    hostname: req.hostname,
    uptime: process.uptime(),
    podname: process.env.HOSTNAME,
  };

  res.status(200).send(response);
});

// Create a new Promotheus client
const register = new promClient.Registry();
register.setDefaultLabels({ app: 'monitoring-counter' });

// Collect default metrics with that client
const collectDefaultMetrics = promClient.collectDefaultMetrics;
collectDefaultMetrics({ register })

// Expose those metrics at /metrics endpoint
app.get('/metrics', async (req: express.Request, res: express.Response) => { 
  res.setHeader('Content-Type', register.contentType); 
  res.send(await register.metrics()); 
});


app.listen(3000, () => {
  console.log('listening on 3000');
});
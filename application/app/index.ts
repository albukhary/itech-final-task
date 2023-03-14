import * as express from 'express';
import * as promClient from 'prom-client';
import 'express-async-errors';

const app = express();

// Define a Prometheus counter metric
const counter = new promClient.Counter({
  name: 'myapp_request_count',
  help: 'Number of requests to my app',
});

// Increase the counter metric for each incoming request
app.use((req: express.Request, res: express.Response, next: express.NextFunction) => {
  counter.inc();
  next();
});

app.get('*', (req: express.Request, res: express.Response) => {
  const response = {
    hostname: req.hostname,
    uptime: process.uptime(),
    podname: process.env.HOSTNAME,
  };

  res.status(200).send(response);
});

// Expose the Prometheus metrics on a /metrics endpoint
app.get('/metrics', (req: express.Request, res: express.Response) => {
  res.set('Content-Type', promClient.register.contentType);
  res.send(promClient.register.metrics());
});

app.listen(3000, () => {
  console.log('listening on 3000');
});
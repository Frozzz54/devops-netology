using Microsoft.AspNetCore.Mvc;
using Sentry;

namespace MySentryTestApp.Controllers;
[ApiController]
[Route("[controller]")]
public class WeatherForecastController : ControllerBase
{
    private static readonly string[] Summaries = new[]
    {
        "Freezing", "Bracing", "Chilly", "Cool", "Mild", "Warm", "Balmy", "Hot", "Sweltering", "Scorching"
    };

    private readonly ILogger<WeatherForecastController> _logger;
    private readonly IHub sentryHub;

    public WeatherForecastController(ILogger<WeatherForecastController> logger, IHub sentryHub)
    {
        _logger = logger;
        this.sentryHub = sentryHub;
    }

    [HttpGet(Name = "GetWeatherForecast")]
    public IEnumerable<WeatherForecast> Get()
    {
        return Enumerable.Range(1, 5).Select(index => new WeatherForecast
        {
            Date = DateOnly.FromDateTime(DateTime.Now.AddDays(index)),
            TemperatureC = Random.Shared.Next(-20, 55),
            Summary = Summaries[Random.Shared.Next(Summaries.Length)]
        })
        .ToArray();
    }

    [HttpGet("Get/{id:int}")]
    public ActionResult<WeatherForecast> Get(int id)
    {
        var childSpan = sentryHub.GetSpan()?.StartChild("additional-work");
        try
        {
            childSpan?.Finish(SpanStatus.Ok);
            return Ok();
        }
        catch (Exception e)
        {
            childSpan?.Finish(e);
            throw;
        }
    }
}
